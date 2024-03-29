module Commontator
  class Subscription < ActiveRecord::Base
    belongs_to :subscriber, :polymorphic => true
    belongs_to :thread

    validates_presence_of :subscriber, :thread
    validates_uniqueness_of :thread_id, :scope => [:subscriber_type, :subscriber_id]

    def self.comment_created(comment)
      practice = Practice.find(comment.thread.commontable_id)
      email_addresses = []
      email_addresses += practice.practice_emails.map(&:address)
      email_addresses << practice.support_network_email&.downcase if practice.support_network_email
      email_addresses << practice.user.email
      email_addresses << comment.parent.creator.email if comment.parent
      email_addresses.reject! {|email| email == comment.creator.email}

      return if email_addresses.empty?

      mail = SubscriptionsMailer.comment_created(comment, email_addresses.uniq)
      mail.deliver_now
    end

    def unread_comments
      created_at = Comment.arel_table[:created_at]
      thread.filtered_comments.where(created_at.gt(updated_at))
    end
  end
end
