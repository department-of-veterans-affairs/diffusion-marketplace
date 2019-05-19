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
  validates_attachment_content_type :origin_picture, content_type: /\Aimage\/.*\z/

  belongs_to :user, optional: true

  has_many :additional_documents, dependent: :destroy
  has_many :additional_resources, dependent: :destroy
  has_many :additional_staffs, dependent: :destroy
  has_many :ancillary_service_practices, dependent: :destroy
  has_many :ancillary_services, through: :ancillary_service_practices
  has_many :badge_practices, dependent: :destroy
  has_many :badges, through: :badge_practices
  has_many :business_case_files, dependent: :destroy
  has_many :category_practices, dependent: :destroy
  has_many :categories, through: :category_practices
  has_many :checklist_files, dependent: :destroy
  has_many :clinical_condition_practices, dependent: :destroy
  has_many :clinical_conditions, through: :clinical_condition_practices
  has_many :clinical_location_practices, dependent: :destroy
  has_many :clinical_locations, through: :clinical_location_practices
  has_many :costs, dependent: :destroy
  has_many :department_practices, dependent: :destroy
  has_many :departments, through: :department_practices
  has_many :developing_facility_type_practices, dependent: :destroy
  has_many :developing_facility_types, through: :developing_facility_type_practices
  has_many :difficulties, dependent: :destroy
  has_many :domain_practices, dependent: :destroy
  has_many :domains, through: :domain_practices
  has_many :financial_files, dependent: :destroy
  has_many :impact_photos, dependent: :destroy
  has_many :implementation_timeline_files, dependent: :destroy
  has_many :job_position_practices, dependent: :destroy
  has_many :job_positions, through: :job_position_practices
  has_many :photo_files, dependent: :destroy
  has_many :practice_management_practices, dependent: :destroy
  has_many :practice_managements, through: :practice_management_practices
  has_many :practice_partner_practices, dependent: :destroy
  has_many :practice_partners, through: :practice_partner_practices
  has_many :practice_permissions, dependent: :destroy
  has_many :publications, dependent: :destroy
  has_many :publication_files, dependent: :destroy
  has_many :required_staff_trainings, dependent: :destroy
  has_many :risk_mitigations, dependent: :destroy
  has_many :survey_result_files, dependent: :destroy
  has_many :timelines, dependent: :destroy
  has_many :toolkit_files, dependent: :destroy
  has_many :user_practices, dependent: :destroy
  has_many :users, through: :user_practices, dependent: :destroy
  has_many :va_employee_practices, dependent: :destroy
  has_many :va_employees, through: :va_employee_practices
  has_many :va_secretary_priority_practices, dependent: :destroy
  has_many :va_secretary_priorities, through: :va_secretary_priority_practices
  has_many :video_files, dependent: :destroy

  accepts_nested_attributes_for :practice_partner_practices, allow_destroy: true
  accepts_nested_attributes_for :impact_photos, allow_destroy: true
  accepts_nested_attributes_for :difficulties, allow_destroy: true
  accepts_nested_attributes_for :risk_mitigations, allow_destroy: true
  accepts_nested_attributes_for :timelines, allow_destroy: true
  accepts_nested_attributes_for :va_employees, allow_destroy: true
  accepts_nested_attributes_for :additional_staffs, allow_destroy: true
  accepts_nested_attributes_for :additional_resources, allow_destroy: true
  accepts_nested_attributes_for :required_staff_trainings, allow_destroy: true


end
