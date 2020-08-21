class PracticeProblemResource < ApplicationRecord
  acts_as_list scope: :practice
  after_create :attachment_crop

  has_attached_file :attachment, styles: {thumb: '768x432>'}, :processors => [:cropper]

  do_not_validate_attachment_file_type :attachment
  belongs_to :practice

  enum resource_type: {image: 0, video: 1, file: 2, link: 3}
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end

  private

  def attachment_crop
    process_attachment_crop({crop_w: @crop_w, crop_h: @crop_h, crop_x: @crop_x, crop_y: @crop_y})
  end
end
