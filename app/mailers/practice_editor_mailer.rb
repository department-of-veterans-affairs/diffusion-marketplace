class PracticeEditorMailer < ApplicationMailer
  default from: ENV['DO_NOT_REPLY_MAILER_SENDER'] || 'do_not_reply@va.gov'
  layout 'mailer'

  def invite_to_edit_practice_email(practice, user)
    practice_user_editor_text = "You have been added to the list of practice editors for the #{practice.name} Diffusion Marketplace Page!"
    practice_editor_text = "You are invited to edit the #{practice.name} Diffusion Marketplace Page!"
    mail(
        to: user.email,
        subject: practice.user === user ? practice_user_editor_text : practice_editor_text
    ) do |format|
      format.html { render "practice_editor_mailer/invite_to_edit_practice_email".html_safe, locals: { practice: practice } }
    end
  end

  def send_batch_email_to_editor(mailer_args)
    @subject = mailer_args[:subject]
    @message = mailer_args[:message]

    user_info = mailer_args[:user_info]
    @user_name = user_info[:user_name] || "Innovation Editor"
    @user_email = user_info[:email]

    @practices = mailer_args[:practices]

    mail(to: user_info[:email], subject: @subject)
  end
end