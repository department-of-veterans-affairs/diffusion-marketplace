class Page < ApplicationRecord
  belongs_to :page_group
  has_many :page_components, -> {order(position: :asc)}, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :page_components, allow_destroy: true
  validates :slug, presence:true, length:{maximum: 255}
  validates :title, presence:true
  validates :description, presence:true
  validates_uniqueness_of :slug
  validates :slug, format: { without: /\s/ }
  validate :string_presence
  validate :downcase_fields
  before_save :downcase_fields

  private
  def downcase_fields
    self.slug = self.slug.downcase
  end

  def string_presence
    if slug.include?("/")
      errors.add(:slug, "URL cannot contain '/'")
      debugger
    end
  end
end
