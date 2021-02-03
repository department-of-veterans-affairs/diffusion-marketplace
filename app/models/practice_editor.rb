class PracticeEditor < ApplicationRecord
  belongs_to :practice
  belongs_to :user

  validates :email, presence: true, format: ApplicationController.helpers.va_email_validation

  def self.create_and_invite(practice, user, email)
    self.create!(practice: practice, user: user, email: email, invited_at: DateTime.current)
  end
end