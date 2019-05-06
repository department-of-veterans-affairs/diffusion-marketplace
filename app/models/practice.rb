class Practice < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  # has_attached_file :main_display_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  has_attached_file :main_display_image, styles: { thumb: '1280x720#' }
  has_attached_file :origin_picture, styles: { thumb: '200x200#' }
  crop_attached_file :main_display_image, aspect: '16:9'
  crop_attached_file :origin_picture, aspect: '1:1'
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
  has_many :practice_permissions
  has_many :publications
  has_many :publication_files
  has_many :required_staff_trainings
  has_many :risk_mitigations
  has_many :practice_partner_practices
  has_many :practice_partners, through: :practice_partner_practices
  has_many :survey_result_files
  has_many :timelines
  has_many :toolkit_files
  has_many :va_employee_practices
  has_many :va_employees, through: :va_employee_practices
  has_many :va_secretary_priority_practices
  has_many :va_secretary_priorities, through: :va_secretary_priority_practices
  has_many :video_files

  accepts_nested_attributes_for :practice_partner_practices, allow_destroy: true
  accepts_nested_attributes_for :impact_photos, allow_destroy: true
  accepts_nested_attributes_for :difficulties, allow_destroy: true
  accepts_nested_attributes_for :risk_mitigations, allow_destroy: true
  accepts_nested_attributes_for :timelines, allow_destroy: true
  accepts_nested_attributes_for :va_employees, allow_destroy: true
  accepts_nested_attributes_for :additional_staffs, allow_destroy: true
  accepts_nested_attributes_for :additional_resources, allow_destroy: true
  accepts_nested_attributes_for :required_staff_trainings, allow_destroy: true

  SATISFACTION_LABELS = ['Little or no impact', 'Some impact', 'Significant impact', 'High or large impact'].freeze
  COST_LABELS = ['0-$10,000', '$10,000-$50,000', '$50,000-$250,000', 'Over $250,000'].freeze
  DIFFICULTY_LABELS = ['Little or no difficulty to implement', 'Some difficulty to implement', 'Significant difficulty to implement', 'High or large difficulty to implement'].freeze
  TIME_ESTIMATE_OPTIONS =['1 week', '1 month', '3 months', '6 months', '1 year', 'longer than 1 year', 'Other (Please specify)']

  def gold_status_first_line
    gold_status_tagline.split('\n')[0]
  end

  def gold_status_second_line
    gold_status_tagline.split('\n')[1]
  end
end
