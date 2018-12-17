class Practice < ApplicationRecord
  acts_as_list
  has_attached_file :main_display_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/

  has_many :ancillary_services, through: :ancillary_service_practices
  has_many :badges, through: :badge_practices
  has_many :clinical_conditions, through: :clinical_condition_practices
  has_many :clinical_locations, through: :clinical_location_practices
  has_many :impacts, through: :impact_practices
  has_many :implementation_timeline_files
  has_many :job_positions, through: :job_position_practices
  has_many :photo_files
  has_many :publications
  has_many :publication_files
  has_many :risk_and_mitigations
  has_many :strategic_sponsors, through: :strategic_sponsor_practices
  has_many :survey_result_files
  has_many :toolkit_files
  has_many :va_secretary_priorities, through: :va_secretary_priority_practices
  has_many :video_files

end
