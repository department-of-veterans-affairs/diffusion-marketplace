# frozen_string_literal: true

require 'net/ldap'

### This is the base class for our Users. ^^ Above comment is for Rubocop
class User < ApplicationRecord
  has_paper_trail
  # Include default devise modules. Others available are:
  # :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :validatable,
         :password_expirable, :password_archivable, :trackable, :timeoutable

  devise :confirmable unless ENV['VAEC_ENV'] == 'true'

  rolify unique: true

  has_many :visits, class_name: 'Ahoy::Visit'
  has_many :user_practices
  has_many :practices, through: :user_practices
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

  USER_ROLES = %w[admin page_group_editor].freeze

  before_validation :clean_work_entries
  validate :valid_email
  validate :password_complexity
  validate :password_uniqueness
  validate :va_email
  validate :validate_work_links, if: :work_changed?

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  after_update :refresh_public_bio_cache, if: :saved_change_to_granted_public_bio?
  after_destroy :refresh_public_bio_cache_if_granted_public_bio

  scope :enabled, -> {where(disabled: false)}
  scope :disabled, -> {where(disabled: true)}
  scope :admins, -> {includes(:roles).where(roles: { name: 'admin' })}
  scope :created_by_date_or_earlier, -> (date) { where('created_at >= ?', date) }

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
    editor_practices = PracticeEditor.where(user: self, innovable_type: 'Practice').collect { |pe| pe.innovable }
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
    return true if /\A[\w+'\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(email)

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
    roles.pluck(:name).join(', ')
  end

  def full_name
    return 'User' unless last_name || first_name

    "#{first_name}#{' ' if last_name && first_name}#{last_name}"
  end

  def preferred_full_name
    first = alt_first_name.presence || first_name
    last = alt_last_name.presence || last_name

    return 'User' if first.blank? && last.blank?

    "#{first}#{' ' if first && last}#{last}"
  end

  def bio_page_name
    "#{preferred_full_name}#{', ' if accolades}#{accolades}"
  end

  def to_param
    "#{id}-#{preferred_full_name.gsub(' ', '-')}"
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
    ldap = Net::LDAP.new(
        host: LDAP_CONFIG['host'], # Thankfully this is a standard name
        port: LDAP_CONFIG['port'],
        encryption: :simple_tls,
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
  end

  def self.ransackable_attributes(auth_object = nil)
    ['first_name', 'email']
  end

  def editable_page_group_ids
    roles.where(name: 'page_group_editor', resource_type: 'PageGroup').pluck(:resource_id)
  end

  def self.validate_users_by_emails(emails)
    emails = emails.map(&:downcase) # VA emails with different capitalization are equivalent
    users = where(email: emails)
    existing_emails = users.pluck(:email)
    non_existent_emails = emails - existing_emails

    [users, non_existent_emails]
  end

  def name_slug
    "#{first_name.downcase}-#{last_name.downcase}"
  end

  def work
    stored_work = read_attribute(:work)

    if stored_work.is_a?(Hash)
      stored_work.values
    else
      stored_work || []
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

  def refresh_public_bio_cache
    Rails.cache.write("users_with_public_bio", User.where(granted_public_bio: true).to_a)
  end

  def refresh_public_bio_cache_if_granted_public_bio
    refresh_public_bio_cache if granted_public_bio?
  end

  def clean_work_entries
    return unless work.is_a?(Array)

    self.work = work.reject { |entry| entry["text"].blank? && entry["link"].blank? }
  end

  def validate_work_links
    return unless work.present?
    domain_pattern = /\.(com|org|net|gov|edu|io|co|us|uk|biz|info|me)\b/i

    work.each do |entry|
      next if entry["link"].blank?

      link = entry["link"].strip
      link = "https://#{link}" unless link.match?(/\Ahttps?:\/\//i)

      begin
        uri = URI.parse(link)
        if (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)) && uri.host&.match?(domain_pattern)
          entry["link"] = ERB::Util.html_escape(link)
        else
          errors.add(:work, "contains an invalid URL in the link field: #{entry['link']}")
        end
      rescue URI::InvalidURIError
        errors.add(:work, "contains an invalid URL in the link field: #{entry['link']}")
      end
    end
  end
end
