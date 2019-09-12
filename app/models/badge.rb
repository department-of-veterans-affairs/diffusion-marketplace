class Badge < ApplicationRecord
  acts_as_list
  has_attached_file :badge_image, validate_media_type: false
  do_not_validate_attachment_file_type :badge_image

  belongs_to :practice_partner, optional: true
  has_many :badge_practices
  has_many :practices, through: :badge_practices

  def badge_image_s3_presigned_url(style = nil)
    object_presigned_url(badge_image, style)
  end
end
