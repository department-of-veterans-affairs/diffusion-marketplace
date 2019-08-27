# frozen_string_literal: true

# Mailer for form emails.
class AdminMailer < ApplicationMailer
  default from: ENV['DO_NOT_REPLY_MAILER_SENDER'] || 'do_not_reply@va.gov'
  layout 'mailer'

  def send_set_password(options = {})
    @user = User.find(options[:user_id])
    @password = options[:password]
    subject = 'Welcome to the VA Diffusion Marketplace'

    mail(to: @user.email, subject: subject)
  end
end
