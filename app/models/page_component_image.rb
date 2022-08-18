class PageComponentImage < ApplicationRecord
  belongs_to :page_component
  has_attached_file :component_image

  validates :component_image, :alt_text, presence: true
  validates_attachment_content_type :component_image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates_with InternalUrlValidator, on: [:create, :update], if: Proc.new { |image| image.url.present? && image.url.chars.first === '/' }
  validates_with ExternalUrlValidator, on: [:create, :update], if: Proc.new { |image| image.url.present? && image.url.chars.first != '/' }

  def component_image_s3_presigned_url(style = nil)
    object_presigned_url(component_image, style)
  end
end