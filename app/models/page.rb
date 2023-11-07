class Page < ApplicationRecord
  has_paper_trail
  belongs_to :page_group

  attr_accessor :delete_image_and_alt_text

  has_many :page_components, -> { order(position: :asc) }, dependent: :destroy, autosave: true
  has_attached_file :image, styles: { thumb: '768x432>' }
  accepts_nested_attributes_for :page_components, allow_destroy: true
  validates :slug, presence: true, length: {maximum: 255}
  validates :title, presence: true
  # prevent DB creation of a page that has a description over 140 characters long
  validates :description, presence: true, length: { maximum: 140 }
  SLUG_FORMAT = /^[a-zA-Z0-9_-]*$*/
  validates_uniqueness_of :slug,
                          scope: :page_group_id,
                          case_sensitive: false

  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z'), message: "invalid characters in URL" }
  validates_attachment :image,
                       content_type: {
                         content_type: %w[image/jpg image/jpeg image/png],
                         message: "must be one of the following types: jpg, jpeg, or png"
                       }
  validates :image_alt_text,
            presence: { message: "can't be blank if Page image is present" },
            if: Proc.new { |page| page.image.present? }
  before_validation :downcase_slug

  enum template_type: { default: 0, narrow: 1 }

  def image_s3_presigned_url(style = nil)
    object_presigned_url(image, style)
  end

  private

  def downcase_slug
    self.slug = self.slug&.downcase
  end
end
