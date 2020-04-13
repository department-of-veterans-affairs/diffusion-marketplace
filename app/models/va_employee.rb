class VaEmployee < ApplicationRecord
  acts_as_list
  has_paper_trail
  has_attached_file :avatar, styles: { thumb: '200x200>' }, :processors => [:cropper]
  do_not_validate_attachment_file_type :avatar
  after_create :avatar_crop

  has_many :va_employee_practices
  has_many :practices, through: :va_employee_practices

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :delete_avatar

  def avatar_s3_presigned_url(style = nil)
    object_presigned_url(avatar, style)
  end

  private

  def avatar_crop
    process_avatar_crop({crop_w: @crop_w, crop_h: @crop_h, crop_x: @crop_x, crop_y: @crop_y})
  end
end
