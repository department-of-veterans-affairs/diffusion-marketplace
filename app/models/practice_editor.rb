class PracticeEditor < ApplicationRecord
  include VaEmail

  belongs_to :practice
  belongs_to :user

  # Add in a failsafe to prevent a practice from having no associated practice editors
  before_destroy do
    ensure_practice_has_at_least_one_practice_editor unless self.destroyed_by_association
  end

  validates :email, presence: true, format: valid_va_email

  def self.create_and_invite(practice, user, email)
    self.create!(practice: practice, user: user, email: email)
    PracticeEditorMailer.invite_to_edit_practice_email(practice, user, email).deliver
  end

  def ensure_practice_has_at_least_one_practice_editor
    if self.practice.practice_editors.count == 1
      errors.add(:base, 'At least one editor is required')
      throw :abort
    end
  end
end