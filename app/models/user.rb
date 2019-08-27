# frozen_string_literal: true

### This is the base class for our Users. ^^ Above comment is for Rubocop
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :password_expirable, :password_archivable, :trackable,
         :timeoutable

  rolify before_add: :remove_all_roles

  has_many :visits, class_name: 'Ahoy::Visit'

  has_many :practices

  has_attached_file :avatar

  USER_ROLES = %w[approver_editor admin].freeze

  validate :valid_email
  validate :password_complexity
  validate :password_uniqueness
  validate :va_email

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

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

  def remove_all_roles(_role)
    self.class::USER_ROLES.each do |r|
      remove_role r
    end
  end

  def full_name
    return 'User' unless last_name || first_name

    "#{first_name} #{last_name}"
  end
end
