class Page < ApplicationRecord
  has_paper_trail
  belongs_to :page_group, inverse_of: :pages
  acts_as_list scope: :page_group

  attr_accessor :delete_image_and_alt_text, :is_subnav_page

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
  validates_attachment_content_type :image,
    content_type: ["image/jpg", "image/jpeg", "image/png"],
    message: "must be one of the following types: jpg, jpeg, or png"
  validates :image_alt_text,
            presence: { message: "can't be blank if Page image is present" },
            if: Proc.new { |page| page.image.present? }
  before_validation :downcase_slug

  enum template_type: { default: 0, narrow: 1 }

  scope :subnav_pages, -> { where.not(position: nil) }

  def image_s3_presigned_url(style = nil)
    object_presigned_url(image, style)
  end

  def self.ransackable_associations(auth_object = nil)
    ["page_components", "page_group", "versions"]
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "description", "title", "slug", "ever_published", "is_visible", "template_type",
      "has_chrome_warning_banner", "image_alt_text", "image_file_name", "image_content_type",
      "image_file_size", "is_public"
    ]
  end

  def is_subnav_page
    self.position.present?
  end

  def add_or_remove_from_community_subnav
    if position.present?
      self.remove_from_list
    else
      new_position = page_group.pages.subnav_pages.count + 1
      self.set_list_position(new_position)
    end
  end

  private

  def downcase_slug
    self.slug = self.slug&.downcase
  end
end
