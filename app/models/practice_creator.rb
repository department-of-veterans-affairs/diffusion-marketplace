class PracticeCreator < ApplicationRecord
  belongs_to :practice
  belongs_to :user, optional: true
  after_create :avatar_crop

  acts_as_list scope: :practice

  # has_one :user, optional: true
  has_attached_file :avatar, styles: { thumb: '200x200>' }, :processors => [:cropper]

  attr_accessor :delete_avatar
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  def avatar_s3_presigned_url(style = nil)
    object_presigned_url(avatar, style)
  end

  private

  def avatar_crop
    process_avatar_crop({crop_w: @crop_w, crop_h: @crop_h, crop_x: @crop_x, crop_y: @crop_y})
  end
end
