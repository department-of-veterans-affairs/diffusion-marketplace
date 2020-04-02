class PracticeCreator < ApplicationRecord
  belongs_to :practice
  belongs_to :user, optional: true
  after_create :process_crop

  acts_as_list scope: :practice

  # has_one :user, optional: true
  has_attached_file :avatar, styles: { thumb: '200x200>' }, :processors => [:cropper]

  attr_accessor :delete_avatar
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  def process_crop
    # using `self` here to circumvent future rubocop offenses
    if @crop_w.present? && @crop_h.present? && @crop_x.present? && @crop_y.present? && self.avatar.present?
      self.crop_x = @crop_x
      self.crop_y = @crop_y
      self.crop_w = @crop_w
      self.crop_h = @crop_h
      self.avatar.reprocess!
    end
  end

  def avatar_s3_presigned_url(style = nil)
    object_presigned_url(avatar, style)
  end
end
