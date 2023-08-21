class PageNewsComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  has_attached_file :image

  FORM_FIELDS = {
    title: 'Title',
    url: 'URL',
    published_date: 'Publication date',
    authors: 'Author(s)',
    text: 'Description',
    image: 'Image',
    image_alt_text: 'Alternative Text'
  }.freeze

  validates_with InternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }

  validates :image_alt_text, presence: true, if: -> { image.present? }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"], if: -> { image.present? }

  def image_s3_presigned_url(style = nil)
    object_presigned_url(image, style)
  end
end
