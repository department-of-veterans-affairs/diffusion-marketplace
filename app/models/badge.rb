class Badge < ApplicationRecord
  acts_as_list
  has_attached_file :badge_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :badge_image, content_type: /\Aimage\/.*\z/

  belongs_to :strategic_sponsor
  has_many :practices, through: :badge_practices
end
