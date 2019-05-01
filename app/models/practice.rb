class Practice < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  # has_attached_file :main_display_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  has_attached_file :main_display_image, styles: { medium: "300x300>", thumb: "100x100>", practice_show: "412x307" }
  has_attached_file :origin_picture
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/

  belongs_to :user, optional: true

  has_many :additional_documents
  has_many :additional_resources
  has_many :additional_staffs
  has_many :ancillary_service_practices
  has_many :ancillary_services, through: :ancillary_service_practices
  has_many :badge_practices
  has_many :badges, through: :badge_practices
  has_many :business_case_files
  has_many :category_practices
  has_many :categories, through: :category_practices
  has_many :checklist_files
  has_many :clinical_condition_practices
  has_many :clinical_conditions, through: :clinical_condition_practices
  has_many :clinical_location_practices
  has_many :clinical_locations, through: :clinical_location_practices
  has_many :costs
  has_many :department_practices
  has_many :departments, through: :department_practices
  has_many :developing_facility_type_practices
  has_many :developing_facility_types, through: :developing_facility_type_practices
  has_many :difficulties
  has_many :domain_practices
  has_many :domains, through: :domain_practices
  has_many :financial_files
  has_many :impact_photos
  has_many :implementation_timeline_files
  has_many :job_position_practices
  has_many :job_positions, through: :job_position_practices
  has_many :photo_files
  has_many :practice_management_practices
  has_many :practice_managements, through: :practice_management_practices
  has_many :publications
  has_many :publication_files
  has_many :required_staff_trainings
  has_many :risk_mitigations
  has_many :practice_partner_practices
  has_many :practice_partners, through: :practice_partner_practices
  has_many :survey_result_files
  has_many :toolkit_files
  has_many :va_employee_practices
  has_many :va_employees, through: :va_employee_practices
  has_many :va_secretary_priority_practices
  has_many :va_secretary_priorities, through: :va_secretary_priority_practices
  has_many :video_files

  def gold_status_first_line
    gold_status_tagline.split('\n')[0]
  end

  def gold_status_second_line
    gold_status_tagline.split('\n')[1]
  end

end
