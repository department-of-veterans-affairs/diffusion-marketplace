class Badge < ApplicationRecord
  acts_as_list
  has_attached_file :badge_image, validate_media_type: false
  do_not_validate_attachment_file_type :badge_image

  belongs_to :strategic_sponsor, optional: true
  has_many :badge_practices
  has_many :practices, through: :badge_practices
end
