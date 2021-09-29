# frozen_string_literal: true

require 'net/ldap'

### This is the base class for our Users. ^^ Above comment is for Rubocop
class User < ApplicationRecord
  has_paper_trail
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :password_expirable,
         :password_archivable, :trackable, :timeoutable

  rolify before_add: :remove_all_roles

  has_many :visits, class_name: 'Ahoy::Visit'

  has_many :user_practices
  has_many :practices, through: :user_practices

  has_many :practice_creators
  has_many :practice_editors, dependent: :destroy

  has_many :practice_editor_sessions

  # This allows users to post comments with the use of the Commontator gem
  acts_as_commontator

  acts_as_voter

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :delete_avatar

  has_attached_file :avatar, styles: { thumb: '300x300>' }, :processors => [:cropper]

  def avatar_s3_presigned_url(style = nil)
    object_presigned_url(avatar, style)
  end

  USER_ROLES = %w[approver_editor admin].freeze

  validate :valid_email
  validate :password_complexity
  validate :password_uniqueness
  validate :va_email

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  scope :enabled, -> {where(disabled: false)}
  scope :disabled, -> {where(disabled: true)}

  paginates_per 50

  def password_complexity
    return true unless encrypted_password_changed?
    return if password.blank?

    pw_strength = 0

    pw_strength += 1 if /(.*?[A-Z])/.match?(password)
    pw_strength += 1 if /(.*?[a-z])/.match?(password)
    pw_strength += 1 if /(.*?[0-9])/.match?(password)
    pw_strength += 1 if /(.*?[#?!@$%^&*-])/.match?(password)

    return true if pw_strength >= 3 && /(.{8,100})/.match?(password)

    errors.add :password, 'complexity requirement not met. Password must include 3 of the following:
                          1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def to_s
    "#{email}"
  end

  def created_practices
    # returns a list of Practices a user has created or can edit
    editor_practices = PracticeEditor.where(user: self).collect { |pe| pe.practice }
    created_practices = Practice.where(user_id: id)
    all_created_practices = (editor_practices + created_practices).uniq
    all_created_practices = all_created_practices.sort_by{ |a| a.retired ? 1 : 0 }
    return all_created_practices
  end

  def password_uniqueness
    return true unless encrypted_password_changed?
    return true if password.split('').uniq.length > 6

    errors.add :password, 'must include 6 unique characters'
  end

  def valid_email
    return true unless email_changed?
    return true if /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(email)

    errors.add :email, 'invalid'
  end

  def va_email
    return true unless email_changed?
    return true if skip_va_validation || email.split('@').last == 'va.gov'

    errors.add :email, 'must use @va.gov email address'
  end

  def remove_all_roles(_role)
    self.class::USER_ROLES.each do |r|
      remove_role r
    end
  end

  def user_role
    roles.collect(&:name).join(', ')
  end

  def full_name
    return 'User' unless last_name || first_name

    "#{first_name}#{' ' if last_name && first_name}#{last_name}"
  end

  def favorite_practices
    user_practices.select(&:favorited).map(&:practice)
  end

  def favorite_practice_ids
    user_practices.select(&:favorited).map(&:practice_id)
  end

  # Authenticates and signs in the User via LDAP
  def self.authenticate_ldap(domain_username)
    user = nil

    begin
      ldap = Net::LDAP.new(
          host: LDAP_CONFIG['host'], # Thankfully this is a standard name
          port: LDAP_CONFIG['port'],
          auth: {method: :simple, username: ENV['LDAP_USERNAME'], password: ENV['LDAP_PASSWORD']},
          base: LDAP_CONFIG['base']
      )
      if ldap.bind
        # Yay, the login credentials were valid!
        # Get the user's full name and return it
        ldap.search(
            filter: Net::LDAP::Filter.eq("sAMAccountName", domain_username),
            attributes: %w[ displayName mail givenName sn title photo jpegphoto thumbnailphoto telephoneNumber postalCode physicalDeliveryOffice streetAddress ],
            return_result: true
        ) do |entry|

          return nil if entry[:mail].blank?
          email = entry[:mail][0].downcase
          user = User.find_by(email: email)

          # create a new user if they do not exist
          user = User.new(email: email) if user.blank?

          # set the user's attributes based on ldap entry
          user.skip_password_validation = true
          user.skip_va_validation = true

          user.first_name = entry[:givenName][0]
          user.last_name = entry[:sn][0]
          user.job_title = entry[:title][0]
          user.phone_number = entry[:telephoneNumber][0]

          # attempt to resolve where the User is VA facility wise
          facilities = VaFacility.cached_va_facilities
          address = entry[:streetAddress][0]
          postal_code = entry[:postalCode][0]
          # Underscore for _location variable to not get confused with the User attribute location
          _location = entry[:physicalDeliveryOffice][0]
          facility = nil
          if address.present?
            # Find the facility by the street address
            facility = facilities.find { |f| f.street_address == address }
            # If the address doesn't match, find it by the postal code
            facility = facilities.find { |f| f.street_address_zip_code == postal_code } if facility.blank?
          else
            # If the address is not prsent, find the facility by the postal code
            facility = facilities.find { |f| f.street_address_zip_code == postal_code }
          end

          # If we found the facility, use it as the location, otherwise, use the physicalDeliveryOffice attribute from AD
          user.facility = facility.station_number if facility.present?
          user.location = facility.present? ? facility.official_station_name : _location
          user.save
        end
      end
      get_ldap_response(ldap)
      user
    # if the .bind method for ldap returns an error, return the user default value (nil)
    rescue
      user
    end
  end

  attr_accessor :skip_password_validation # virtual attribute to skip password validation while saving

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

  private

  def self.get_ldap_response(ldap)
    msg = "Response Code: #{ ldap.get_operation_result.code }, Message: #{ ldap.get_operation_result.message }"

    raise msg unless ldap.get_operation_result.code == 0
  end
end
