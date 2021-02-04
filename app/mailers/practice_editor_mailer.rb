class PracticeEditorMailer < ApplicationMailer
  layout 'mailer'

  def invite_to_edit_practice_email(practice, user, email)
    mail(
        from: ENV['DO_NOT_REPLY_MAILER_SENDER'] || 'do_not_reply@va.gov',
        to: email,
        subject: "You are invited to edit the #{practice.name} Diffusion Marketplace Page!"
    ) do |format|
      format.text
      format.html { render "practice_editor_mailer/invite_to_edit_practice_email".html_safe, locals: { practice: practice } }
    end
  end
end