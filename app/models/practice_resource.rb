class PracticeResource < ApplicationRecord
  acts_as_list scope: :practice
  after_create :attachment_crop

  has_attached_file :attachment, styles: {thumb: '768x432>'}, :processors => [:cropper]
  before_post_process :skip_for_non_image

  do_not_validate_attachment_file_type :attachment
  belongs_to :practice

  enum resource_type: {core: 0, optional: 1, support: 2}
  enum media_type: {resource: 0, file: 1, link: 2}
  enum resource_type_label: {people: 0, processes: 1, tools: 2}

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end

  private

  def skip_for_non_image
    %w(image/jpg image/jpeg image/png).include?(attachment_content_type)
  end

  def attachment_crop
    process_attachment_crop({crop_w: @crop_w, crop_h: @crop_h, crop_x: @crop_x, crop_y: @crop_y})
  end
end
