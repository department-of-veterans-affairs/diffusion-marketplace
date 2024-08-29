class HomepageFeature < ApplicationRecord
  belongs_to :homepage
  has_attached_file :featured_image
  validates_attachment_content_type :featured_image, content_type: /\Aimage\/.*\z/, if: -> { featured_image.present? }

  attr_accessor :delete_image
  before_save :check_image_deletion

  def image_s3_presigned_url(style = nil)
    if featured_image.present?
      object_presigned_url(featured_image, style)
    end
  end

  def self.column_size(item_count = 3)
    if item_count >= 3
      'three-column-layout'
    else # update this later to deal with incoming designs
      'two-column-layout'
    end
  end

  private

  def check_image_deletion
    if delete_image == '1'
      self.featured_image.destroy
      self.image_alt_text = nil
    end
  end
end
