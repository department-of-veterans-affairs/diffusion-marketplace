class VaEmployee < ApplicationRecord
  acts_as_list
  has_paper_trail
  has_attached_file :avatar, styles: { thumb: '200x200>' }, :processors => [:cropper]
  do_not_validate_attachment_file_type :avatar
  after_create :process_crop

  has_many :va_employee_practices
  has_many :practices, through: :va_employee_practices

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :delete_avatar

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
