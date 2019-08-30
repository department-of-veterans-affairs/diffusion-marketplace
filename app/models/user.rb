# frozen_string_literal: true

require 'net/ldap'

### This is the base class for our Users. ^^ Above comment is for Rubocop
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :validatable,
         :password_expirable, :password_archivable, :trackable,
         :timeoutable

  rolify before_add: :remove_all_roles

  has_many :practices

  USER_ROLES = %w[approver_editor admin].freeze

  validate :valid_email
  validate :password_complexity
  validate :password_uniqueness
  validate :va_email

  scope :enabled,   -> { where(disabled: false) }
  scope :disabled,  -> { where(disabled: true) }

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

  def remove_all_roles(role)
    self.class::USER_ROLES.each do |r|
      remove_role r
    end
  end

  def full_name
    return 'User' unless last_name || first_name
    "#{first_name} #{last_name}"
  end

  # Authenticates the User via LDAP and saves their LDAP photo if they have one
  def self.authenticate_ldap(domain_username)
    user = nil
    # raise ArgumentError, 'domain is nil' if domain.nil? or domain.blank?
    # raise ArgumentError, 'password is nil' if password.nil? or password.blank?

    # ldap      = Net::LDAP.new
    # ldap.host = LDAP_CONFIG['host']
    # ldap.port = LDAP_CONFIG['port']
    # ldap.auth "#{domain}\\#{login}", password
    # bound = ldap.bind
    ldap = Net::LDAP.new(
        host: LDAP_CONFIG['host'],    # Thankfully this is a standard name
        port: LDAP_CONFIG['port'],
        auth: { method: :simple, username: ENV['LDAP_USERNAME'], password: ENV['LDAP_PASSWORD'] },
        base: LDAP_CONFIG['base']
    )
    # ldap.auth(ENV['LDAP_USERNAME'], ENV['LDAP_PASSWORD'])
    # logger.info "#{ENV['LDAP_USERNAME']}, #{ENV['LDAP_PASSWORD']}"
    if ldap.bind
      logger.info "LDAP bind: #{ldap.inspect}"
      # Yay, the login credentials were valid!
      # Get the user's full name and return it
      ldap.search(
          # base:         LDAP_CONFIG['base'],
          filter:       Net::LDAP::Filter.eq( "sAMAccountName", domain_username ),
          attributes:   %w[ displayName mail givenName sn ],
          return_result:true
      ) do |entry|
        logger.info "-----LDAP user inspect:-----"
        logger.info "#{entry.inspect} "
        # logger.info "#{entry.attribute_names} "
        # logger.info "#{entry[:mail]}"

        return nil if entry[:mail].blank?
        email = entry[:mail][0].downcase
        user = User.find_by(email: email)

        logger.info "user: #{user.inspect}"

        if user.blank?
          # create the user
          user = User.new(email: email)
          user.skip_password_validation = true
          user.skip_va_validation = true
          user.save
          logger.info "#{user.email}"
          logger.info "#{user.errors.inspect}"
        else
          # update user attributes
        end
      end
    end
    get_ldap_response(ldap)
    # if bound

    # photo_path = "#{Rails.public_path}/images/avatars/#{id}.jpg"
    # unless File.exists?(photo_path)
    #   base   = LDAP_CONFIG['base']
    #   filter = Net::LDAP::Filter.eq('sAMAccountName', login)
    #   ldap.search(:base => base, :filter => filter, :return_result => true) do |entry|
    #     [:thumbnailphoto, :jpegphoto, :photo].each do |photo_key|
    #       if entry.attribute_names.include?(photo_key)
    #         @ldap_photo = entry[photo_key][0]
    #         File.open(photo_path, 'wb') { |f| f.write(@ldap_photo) }
    #         break
    #       end
    #     end
    #   end
    # end
    # end
    # bound
    #
    user
  end

  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving

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
