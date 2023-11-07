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
    @thread = comment.thread
    @creator = comment.creator
    @creator_name = Commontator.commontator_name(@creator)
    @commontable_name = @comment.thread.commontable.name
    @practice_name = @thread.commontable.name
    @comment_url = build_comment_url
    @comment_header = build_comment_header
    setup_mail_params(recipients)
  end

  private

  def setup_mail_params(recipients)
    @mail_params = {
      from: @thread.config.email_from_proc.call(@thread),
      to: @using_mailgun ? recipients : nil,
      bcc: @using_mailgun ? nil : recipients,
      subject: build_subject
    }
    setup_mailgun_variables(recipients) if @using_mailgun
  end

  def setup_mailgun_variables(recipients)
    @mailgun_recipient_variables = recipients.each_with_object({}) { |recipient, vars| vars[recipient] = {} }
  end

  def build_comment_url
    base_url, anchor = Commontator.comment_url(@comment, main_app).split('#')
    anchor_prefix = "commontator-comment-"
    anchor_suffix = @comment.parent_id.nil? ? @comment.id.to_s : @comment.parent_id.to_s
    "#{base_url}##{anchor_prefix}#{anchor_suffix}"
  end

  def build_comment_header
    comment_user = User.find(@comment.creator_id).full_name
    action = @comment.parent_id.nil? ? 'commented on' : 'replied to a comment on'
    "#{comment_user} has #{action} #{@commontable_name}"
  end

  def build_subject
    action = @comment.parent_id.nil? ? 'commented on' : 'replied to a comment on'
    "Someone has #{action} #{@commontable_name} in Diffusion Marketplace"
  end
end
