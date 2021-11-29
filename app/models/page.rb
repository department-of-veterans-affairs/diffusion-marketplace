class Page < ApplicationRecord
  has_paper_trail
  belongs_to :page_group
  has_many :page_components, -> { order(position: :asc) }, dependent: :destroy, autosave: true
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
  validate :downcase_fields
  before_create :downcase_fields

  enum template_type: {default: 0, narrow: 1}

  private

  def downcase_fields
    self.slug = self.slug.downcase
  end
end
