class Commontator::SubscriptionsMailer < ActionMailer::Base
  helper Commontator::SharedHelper
  def comment_created(comment, recipients)
    setup_variables(comment, recipients)

    mail(@mail_params).tap do |message|
      message.mailgun_recipient_variables = @mailgun_recipient_variables if @using_mailgun
    end
  end

  protected

  def setup_variables(comment, recipients)
    @comment = comment
    comment_user = User.find(comment.creator_id).full_name
    @comment_header = "#{comment_user} has commented on #{@comment.thread.commontable.name}"
    @comment_header = "#{comment_user} has replied to a comment on #{@comment.thread.commontable.name}" unless @comment.parent_id.nil?
    @thread = @comment.thread
    @creator = @comment.creator
    @mail_params = { from: @thread.config.email_from_proc.call(@thread) }
    practice = Practice.find(@comment.thread.commontable_id)
    support_network_email = practice.support_network_email || nil
    @recipient_emails = recipients.map do |recipient|
      support_network_email.present? && recipient === support_network_email.downcase ? recipient : Commontator.commontator_email(recipient, self)
    end
    @using_mailgun = Rails.application.config.action_mailer.delivery_method == :mailgun
    if @using_mailgun
      @recipients_header = :to
      @mailgun_recipient_variables = {}.tap do |mailgun_recipient_variables|
        @recipient_emails.each { |email| mailgun_recipient_variables[email] = {} }
      end
    else
      @recipients_header = :bcc
    end
    @mail_params[@recipients_header] = @recipient_emails
    @creator_name = Commontator.commontator_name(@creator)
    @commontable_name = Commontator.commontable_name(@thread)
    @comment_url = Commontator.comment_url(@comment, main_app)
    @comment_url = @comment_url.split('#')[0] + "#commontator-comment-"
    if @comment.parent_id.nil?
      @comment_url += @comment.id.to_s
    else
      @comment_url += @comment.parent.id.to_s
    end
    @practice_name = @comment.thread.commontable.name
    subject = "Someone has commented on #{@comment.thread.commontable.name} in Diffusion Marketplace"
    subject = "Someone has replied to a comment on #{@comment.thread.commontable.name} in Diffusion Marketplace" unless @comment.parent_id.nil?
    @mail_params[:subject] = subject
  end
end
