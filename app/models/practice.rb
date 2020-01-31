class Practice < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  visitable :ahoy_visit

  attr_accessor :views
  attr_accessor :current_month_views
  attr_accessor :last_month_views
  attr_accessor :two_months_ago_views
  attr_accessor :three_months_ago_views
  attr_accessor :current_month_commits
  attr_accessor :last_month_commits
  attr_accessor :two_months_ago_commits
  attr_accessor :three_months_ago_commits

  def views
    Ahoy::Event.where_props(practice_id: id).count
  end

  def current_month_views
    date_range_views(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  def last_month_views
    date_range_views((Date.today - 1.months).at_beginning_of_month, (Date.today - 1.months).at_end_of_month)
  end

  def two_months_ago_views
    date_range_views((Date.today - 2.months).at_beginning_of_month, (Date.today - 2.months).at_end_of_month)
  end

  def three_months_ago_views
    date_range_views((Date.today - 3.months).at_beginning_of_month, (Date.today - 3.months).at_end_of_month)
  end

  def current_month_commits
    committed_user_count_by_range(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  def last_month_commits
    committed_user_count_by_range((Date.today - 1.months).at_beginning_of_month, (Date.today - 1.months).at_end_of_month)
  end

  def two_months_ago_commits
    committed_user_count_by_range((Date.today - 2.months).at_beginning_of_month, (Date.today - 2.months).at_end_of_month)
  end

  def three_months_ago_commits
    committed_user_count_by_range((Date.today - 3.months).at_beginning_of_month, (Date.today - 3.months).at_end_of_month)
  end

  has_paper_trail
  # has_attached_file :main_display_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  has_attached_file :main_display_image, styles: { thumb: '1280x720#' }

  def main_display_image_s3_presigned_url(style = nil)
    object_presigned_url(main_display_image, style)
  end

  has_attached_file :origin_picture, styles: { thumb: '200x200#' }

  def origin_picture_s3_presigned_url(style = nil)
    object_presigned_url(origin_picture, style)
  end

  crop_attached_file :main_display_image, aspect: '16:9'
  crop_attached_file :origin_picture, aspect: '1:1'
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :origin_picture, content_type: /\Aimage\/.*\z/
  validates :name, presence: { message: 'Practice name can\'t be blank'}
  validates :tagline, presence: { message: 'Practice tagline can\'t be blank'}

  scope :published,   -> { where(published: true) }
  scope :unpublished,  -> { where(published: false) }

  belongs_to :user, optional: true

  has_many :additional_documents, -> {order(position: :asc)}, dependent: :destroy
  has_many :additional_resources, -> {order(position: :asc)}, dependent: :destroy
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
  has_many :diffusion_histories, dependent: :destroy
  has_many :domain_practices, dependent: :destroy
  has_many :domains, through: :domain_practices
  has_many :financial_files, dependent: :destroy
  has_many :impact_photos, -> {order(position: :asc)}, dependent: :destroy
  has_many :implementation_timeline_files, dependent: :destroy
  has_many :job_position_practices, dependent: :destroy
  has_many :job_positions, through: :job_position_practices
  has_many :photo_files, dependent: :destroy
  has_many :practice_management_practices, dependent: :destroy
  has_many :practice_managements, through: :practice_management_practices
  has_many :practice_partner_practices, dependent: :destroy
  has_many :practice_partners, through: :practice_partner_practices
  has_many :practice_permissions, -> {order(position: :asc)}, dependent: :destroy
  has_many :publications, -> {order(position: :asc)}, dependent: :destroy
  has_many :publication_files, dependent: :destroy
  has_many :required_staff_trainings, dependent: :destroy
  has_many :risk_mitigations, -> {order(position: :asc)}, dependent: :destroy
  has_many :survey_result_files, dependent: :destroy
  has_many :timelines, -> {order(position: :asc)}, dependent: :destroy
  has_many :toolkit_files, dependent: :destroy
  has_many :user_practices, dependent: :destroy
  has_many :users, through: :user_practices, dependent: :destroy
  has_many :va_employee_practices, dependent: :destroy
  has_many :va_employees, -> {order(position: :asc)}, through: :va_employee_practices
  has_many :va_secretary_priority_practices, dependent: :destroy
  has_many :va_secretary_priorities, through: :va_secretary_priority_practices
  has_many :video_files, -> {order(position: :asc)}, dependent: :destroy
  has_many :practice_creators, -> {order(position: :asc)}, dependent: :destroy

  # This allows the practice model to be commented on with the use of the Commontator gem
  acts_as_commontable dependent: :destroy

  accepts_nested_attributes_for :practice_partner_practices, allow_destroy: true
  accepts_nested_attributes_for :impact_photos, allow_destroy: true
  accepts_nested_attributes_for :video_files, allow_destroy: true
  accepts_nested_attributes_for :difficulties, allow_destroy: true
  accepts_nested_attributes_for :risk_mitigations, allow_destroy: true
  accepts_nested_attributes_for :timelines, allow_destroy: true
  accepts_nested_attributes_for :va_employees, allow_destroy: true
  accepts_nested_attributes_for :additional_staffs, allow_destroy: true
  accepts_nested_attributes_for :additional_resources, allow_destroy: true
  accepts_nested_attributes_for :required_staff_trainings, allow_destroy: true
  accepts_nested_attributes_for :practice_creators, allow_destroy: true
  accepts_nested_attributes_for :practice_permissions, allow_destroy: true
  accepts_nested_attributes_for :additional_documents, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? || attributes['attachment'].nil? }
  accepts_nested_attributes_for :publications, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? || attributes['link'].blank? }

  SATISFACTION_LABELS = ['Little or no impact', 'Some impact', 'Significant impact', 'High or large impact'].freeze
  COST_LABELS = ['0-$10,000', '$10,000-$50,000', '$50,000-$250,000', 'More than $250,000'].freeze
  # also known as "Difficulty"
  COMPLEXITY_LABELS = ['Little or no complexity', 'Some complexity', 'Significant complexity', 'High or large complexity'].freeze
  TIME_ESTIMATE_OPTIONS =['1 week', '1 month', '3 months', '6 months', '1 year', 'longer than 1 year', 'Other (Please specify)']
  NUMBER_DEPARTMENTS_OPTIONS =['1. Single department', '2. Two departments', '3. Three departments', '4. Four or more departments']

  def committed_user_count
    users.count
  end

  def committed_user_count_by_range(start_date, end_date)
    users.where(created_at:start_date..end_date).count
  end

  def number_of_adopted_facilities
    number_adopted
  end

  def date_range_views(start_date, end_date)
    Ahoy::Event.where_props(practice_id: id).where(time: start_date..end_date).count
  end
end
