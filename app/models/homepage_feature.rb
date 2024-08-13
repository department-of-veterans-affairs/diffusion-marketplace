class HomepageFeature < ApplicationRecord
  belongs_to :homepage
  has_attached_file :featured_image
  validates_attachment_content_type :featured_image, content_type: /\Aimage\/.*\z/, if: -> { featured_image.present? }
  validates :section_id, presence: true, allow_nil: false
  # validate :any_fields_filled?

  attr_accessor :delete_image
  before_save :check_image_deletion

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def image_s3_presigned_url(style = nil)
    object_presigned_url(featured_image, style)
  end

  def any_fields_filled?
    return attributes.except("id", "created_at", "updated_at", "homepage_id", "section_id").values.any?(&:present?)
  end

  def empty_fields? 
    return true if any_fields_filled? == false
  end

  private

  def check_image_deletion
    self.featured_image.destroy if delete_image == '1'
    self.image_alt_text = nil
  end
end