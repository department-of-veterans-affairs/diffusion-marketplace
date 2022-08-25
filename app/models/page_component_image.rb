class PageComponentImage < ApplicationRecord
  belongs_to :page_component
  has_attached_file :image

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  def image_s3_presigned_url(style = nil)
    object_presigned_url(image, style)
  end
end