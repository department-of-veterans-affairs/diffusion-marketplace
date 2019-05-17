# Mailer for form emails.
class PracticeMailer < ApplicationMailer
  default from: ENV['DO_NOT_REPLY_MAILER_SENDER'] || 'do_not_reply@va.gov'
  layout 'mailer'

  def commitment_response_email(options = {})
    @user = options[:user]
    @practice = options[:practice]
    subject = "Thank you for committing to implement #{@practice.name}"

    mail(to: @user.email, subject: subject)
  end

  def support_team_notification_of_commitment(options = {})
    @user = options[:user]
    @practice = options[:practice]
    subject = "There is interest in implementing your practice!"

    mail(to: @practice.support_network_email, subject: subject)
  end
end
