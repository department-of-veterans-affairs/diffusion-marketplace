class PracticeCreator < ApplicationRecord
  belongs_to :practice
  belongs_to :user, optional: true

  acts_as_list scope: :practice

  # has_one :user, optional: true
  has_attached_file :avatar

  attr_accessor :delete_avatar

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  def avatar_s3_presigned_url(style = nil)
    object_presigned_url(avatar, style)
  end
end
