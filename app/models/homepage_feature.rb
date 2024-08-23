class HomepageFeature < ApplicationRecord
  belongs_to :homepage
  has_attached_file :featured_image
  validates_attachment_content_type :featured_image, content_type: /\Aimage\/.*\z/, if: -> { featured_image.present? }
  # validates :section_id, presence: true, allow_nil: true

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


  private

  def check_image_deletion
    self.featured_image.destroy if delete_image == '1'
    self.image_alt_text = nil
  end
end