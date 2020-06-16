class PageImageComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  has_attached_file :page_image

  validates :page_image, :alt_text, presence: true
  validates_attachment_content_type :page_image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  def page_image_s3_presigned_url(style = nil)
    object_presigned_url(page_image, style)
  end
end
