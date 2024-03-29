class Commontator::SubscriptionsMailer < ActionMailer::Base
  helper Commontator::SharedHelper

  def comment_created(comment, recipients)
    setup_variables(comment, recipients)
    mail(@mail_params)
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
      bcc: recipients,
      subject: build_subject
    }
  end

  def build_comment_url
    base_url, anchor = Commontator.comment_url(@comment, main_app).split('#')
    anchor_prefix = "commontator-comment-"
    anchor_suffix = @comment.parent_id.nil? ? @comment.id.to_s : @comment.parent_id.to_s
    "#{base_url}##{anchor_prefix}#{anchor_suffix}"
  end

  def build_comment_header
    comment_user = User.find(@comment.creator_id).full_name
    comment_parent = User.find_by_id(@comment.parent&.creator_id)
    action = comment_parent.nil? ? 'commented on' : "replied to #{comment_parent.full_name}'s comment on"
    "#{comment_user} has #{action} #{@commontable_name}"
  end

  def build_subject
    action = @comment.parent_id.nil? ? 'commented on' : 'replied to a comment on'
    "Someone has #{action} #{@commontable_name} in Diffusion Marketplace"
  end
end
