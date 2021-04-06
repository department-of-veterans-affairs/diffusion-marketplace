class PageImageComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  has_attached_file :page_image

  validates :page_image, :alt_text, presence: true
  validates_attachment_content_type :page_image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates_with InternalUrlValidator, on: [:create, :update], if: Proc.new { |page_component| page_component.url.present? && page_component.url.chars.first === '/' }
  validates_with ExternalUrlValidator, on: [:create, :update], if: Proc.new { |page_component| page_component.url.present? && page_component.url.chars.first != '/' }

  def page_image_s3_presigned_url(style = nil)
    object_presigned_url(page_image, style)
  end
end
