module Commontator
  class Subscription < ActiveRecord::Base
    belongs_to :subscriber, :polymorphic => true
    belongs_to :thread

    validates_presence_of :subscriber, :thread
    validates_uniqueness_of :thread_id, :scope => [:subscriber_type, :subscriber_id]

    def self.comment_created(comment)
      practice = Practice.find(comment.thread.commontable_id)
      support_network_email = practice.support_network_email || nil
      support_network_email_user = support_network_email.present? ? User.find_by(email: support_network_email.downcase) : nil
      subscribers = comment.thread.subscribers

      if support_network_email.present? && support_network_email_user.nil?
        subscribers.push(practice.user, support_network_email.downcase)
      elsif support_network_email.present? && support_network_email_user.present?
        subscribers.push(practice.user, support_network_email_user)
      else
        subscribers.push(practice.user)
      end
      # filter out the comment creator and/or any duplicate subscribers
      recipients = subscribers.reject { |s| s == comment.creator }.compact.uniq

      return if recipients.empty?

      mail = SubscriptionsMailer.comment_created(comment, recipients)
      mail.deliver_now
    end

    def unread_comments
      created_at = Comment.arel_table[:created_at]
      thread.filtered_comments.where(created_at.gt(updated_at))
    end
  end
end
