class PracticeEditorMailer < ApplicationMailer
  default from: ENV['DO_NOT_REPLY_MAILER_SENDER'] || 'do_not_reply@va.gov'
  layout 'mailer'
  MAILER_RETURN = "marketplace@va.gov"

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

  def send_batch_email_to_editor(args)
    @subject = args["subject"]
    @message = args["message"]
    user_info = args["practices_data"]["user_info"]
    @user_name = user_info["user_name"] || "Innovation Editor"
    @practices = args["practices_data"]["practices"]

    mail(to: user_info["email"], subject: @subject)
  end

  def send_batch_email_confirmation(args)
    @message_subject = args["subject"]
    @message = args["message"]
    @practice_names = args["practices_data"]
    @filters = args["filters"]

    subject = if @practice_names.empty?
                    "Failure: Diffusion Marketplace Innovation Batch Emails Not Sent"
                  else
                    "Confirmation: Diffusion Marketplace Innovation Batch Emails Sent"
                  end

    # Send confirmation to DM email only on PROD, local and test
    # In DEV send confirmation only to current_user that triggered the batch emails
    if Rails.env.production? && ENV['PROD_SERVERNAME'] != 'PROD'
      recipients = args["sender_email_address"]
    else
      recipients = [args["sender_email_address"], MAILER_RETURN]
    end

    mail(to: recipients, subject: subject)
  end
end
