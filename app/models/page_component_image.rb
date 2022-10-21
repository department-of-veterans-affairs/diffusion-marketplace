class PageComponentImage < ApplicationRecord
  belongs_to :page_component
  has_attached_file :image, styles: { thumb: '768x432>' }

  validates_attachment :image,
                       presence: { message: "can't be blank" },
                       content_type: {
                         content_type: %w[image/jpg image/jpeg image/png],
                         message: "must be one of the following types: jpg, jpeg, or png"
                       }
  validates :alt_text, presence: { message: "can't be blank" }
  validates_with InternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }

  def image_s3_presigned_url(style = nil)
    object_presigned_url(image, style)
  end
end