class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :password_expirable, :password_archivable

  rolify before_add: :remove_unauthenticated

  USER_ROLES = %w[unauthenticated authenticated approver_editor admin].freeze

  validate :valid_email
  validate :password_complexity
  validate :password_uniqueness
  validate :va_email

  def password_complexity
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
    return true if password.split('').uniq.length > 6

    errors.add :password, 'must include 6 unique characters'
  end

  def valid_email
    return true if /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(email)

    errors.add :email, 'invalid'
  end

  def va_email
    return true if skip_va_validation || email.split('@').last == 'va.gov'

    errors.add :email, 'must use @va.gov email address'
  end

  def self.confirm_by_token(confirmation_token)
    confirmable = find_first_by_auth_conditions(confirmation_token: confirmation_token)
    unless confirmable
      confirmation_digest = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
      confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_digest)
    end

    # TODO: replace above lines with
    # confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    # after enough time has passed that Devise clients do not use digested tokens
    confirmable.add_role USER_ROLES[1] if confirmable.persisted?
    confirmable.confirm if confirmable.persisted?
    confirmable
  end

  def remove_unauthenticated(role)
    remove_role self.class::USER_ROLES[0] if role != self.class::USER_ROLES[0]
  end
end
