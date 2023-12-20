# Mailer for form emails.
class AdminMailer < ApplicationMailer
  default from: ENV['DO_NOT_REPLY_MAILER_SENDER'] || 'do_not_reply@va.gov'
  layout 'mailer'

  def send_set_password(options = {})
    @user = User.find(options[:user_id])
    @password = options[:password]
    subject = "Welcome to the VA Diffusion Marketplace"

    mail(to: @user.email, subject: subject)
  end

  def send_email_to_editor(mailer_args)
    @subject = mailer_args[:subject]
    @message = mailer_args[:message]

    user_info = mailer_args[:user_info]
    @user_name = user_info[:user_name] || "Innovation Editor"
    @user_email = user_info[:email]

    @practices = mailer_args[:practices]

    mail(to: user_info[:email], subject: @subject)
  end
end
