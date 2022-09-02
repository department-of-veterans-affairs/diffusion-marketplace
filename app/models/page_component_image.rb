class PageComponentImage < ApplicationRecord
  belongs_to :page_component
  has_attached_file :image

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates_with InternalUrlValidator, on: [:create, :update], if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator, on: [:create, :update], if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }

  def image_s3_presigned_url(style = nil)
    object_presigned_url(image, style)
  end
end