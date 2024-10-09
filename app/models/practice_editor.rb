class PracticeEditor < ApplicationRecord
  include VaEmail

  belongs_to :innovable, polymorphic: true
  belongs_to :user

  attr_accessor :email

  # Add in a failsafe to prevent a practice from having no associated practice editors
  before_destroy do
    ensure_practice_has_at_least_one_practice_editor unless self.destroyed_by_association
  end

  validates :email, presence: true, format: valid_va_email, on: :create

  def self.create_and_invite(practice, user)
    # Email param ensures the user associated with the practice editor has a valid va.gov email address
    self.create!(innovable: practice, user: user, email: user.email)
    if (Rails.env.production? && ENV['PROD_SERVERNAME'] == 'PROD') || Rails.env.test?
      PracticeEditorMailer.invite_to_edit(practice, user).deliver
    end
  end

  def ensure_practice_has_at_least_one_practice_editor
    if self.innovable.practice_editors.count == 1
      errors.add(:base, 'At least one editor is required')
      throw :abort
    end
  end
end
