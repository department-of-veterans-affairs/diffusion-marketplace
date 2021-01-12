class Practice < ApplicationRecord
  include ActiveModel::Dirty

  before_save :clear_searchable_cache_on_save
  after_save :reset_searchable_practices

  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  visitable :ahoy_visit
  enum initiating_facility_type: { facility: 0, visn: 1, department: 2, other: 3 }
  enum maturity_level: { emerging: 0, replicate: 1, scale: 2 }

  attr_accessor :views
  attr_accessor :current_month_views
  attr_accessor :last_month_views
  attr_accessor :two_months_ago_views
  attr_accessor :three_months_ago_views
  attr_accessor :current_month_commits
  attr_accessor :last_month_commits
  attr_accessor :two_months_ago_commits
  attr_accessor :three_months_ago_commits
  attr_accessor :delete_main_display_image
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :practice_partner, :department, :practice_award, :category
  attr_accessor :reset_searchable_cache

  def clear_searchable_cache
    cache_keys = ["searchable_practices", "searchable_practices_a_to_z", "searchable_practices_adoptions", "searchable_practices_added"]
    cache_keys.each do |cache_key|
      Rails.cache.delete(cache_key)
    end
  end

  def clear_searchable_cache_on_save
    if self.name_changed? ||
        self.tagline_changed? ||
        self.description_changed? ||
        self.summary_changed? ||
        self.initiating_facility_changed? ||
        self.main_display_image_updated_at_changed? ||
        self.published_changed? ||
        self.enabled_changed? ||
        self.date_initiated_changed? ||
        self.maturity_level_changed?
      self.reset_searchable_cache = true
    end
  end

  def reset_searchable_practices
    clear_searchable_cache if self.reset_searchable_cache
  end

  def self.searchable_practices(sort = 'a_to_z')
    if sort == 'a_to_z'
      Rails.cache.fetch('searchable_practices_a_to_z') do
        Practice.sort_a_to_z.get_with_categories_and_adoptions_ct
      end
    elsif sort == 'adoptions'
      Rails.cache.fetch('searchable_practices_adoptions') do
        Practice.sort_adoptions_ct.get_with_categories_and_adoptions_ct
      end
    elsif sort == 'added'
      Rails.cache.fetch('searchable_practices_added') do
        Practice.sort_added.get_with_categories_and_adoptions_ct
      end
    elsif sort == nil
      Rails.cache.fetch('searchable_practices') do
        Practice.get_with_categories_and_adoptions_ct
      end
    end
  end

  def has_facility?
    if self.facility?
      self.practice_origin_facilities.present?
    elsif self.department?
      self.initiating_department_office_id.present? && self.initiating_facility.present?
    elsif self.visn? || self.other?
      self.initiating_facility.present?
    end
  end

  # views
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

  # commits
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

  # favorited
  def current_month_favorited
    favorited_count_by_range(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  def last_month_favorited
    favorited_count_by_range((Date.today - 1.months).at_beginning_of_month, (Date.today - 1.months).at_end_of_month)
  end

  has_paper_trail
  # has_attached_file :main_display_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  # crop the img with custom Paperclip processor located in lib/paperclip_processors/cropper.rb
  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]

  def main_display_image_s3_presigned_url(style = nil)
    object_presigned_url(main_display_image, style)
  end

  has_attached_file :origin_picture, styles: {thumb: '200x200#'}

  def origin_picture_s3_presigned_url(style = nil)
    object_presigned_url(origin_picture, style)
  end

  PRACTICE_EDITOR_SLUGS =
      {
          'introduction': 'instructions',
          'adoptions': 'introduction',
          'overview': 'adoptions',
          'implementation': 'overview',
          'contact': 'implementation',
          'about': 'contact',
      }

  PRACTICE_EDITOR_AWARDS_AND_RECOGNITION =
      [
        'Diffusion of Excellence Promising Practice',
        'FedHealth IT Award',
        'Gears of Government Winner',
        'Igniting Innovation Award',
        'iNET Seed Investee',
        'iNet Spark Award Investee',
        'iNET Spread Investee',
        'QUERI Veterans Choice Act Award',
        'QUERI VISN Partnered Implementation Initiative',
        'QUERI Partnered Evaluation Initiative',
        'Rural Promising Practice',
        'VHA Shark Tank Winner',
        'Other'
      ]

  MATURITY_LEVEL_MAP = {
      emerging: {
          link_text: 'emerging',
          description: 'This practice is <b>emerging</b> and worth watching as it is being assessed in early implementations.'.html_safe
      },
      replicate: {
          link_text: 'replicating',
          description: 'This practice is <b>replicating</b> across multiple facilities as its impact continues to be validated.'.html_safe
      },
      scale: {
          link_text: 'scaling',
          description: 'This practice is <b>scaling</b> widely with the support of national stakeholders.'.html_safe
      }
  }


  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :origin_picture, content_type: /\Aimage\/.*\z/
  validates_uniqueness_of :name, {message: 'Practice name already exists'}
  # validates :tagline, presence: { message: 'Practice tagline can\'t be blank'}

  scope :published,   -> { where(published: true) }
  scope :unpublished,  -> { where(published: false) }
  scope :get_practice_owner_emails, -> {where.not(user_id: nil)}
  scope :get_with_categories_and_adoptions_ct, -> { left_outer_joins(:diffusion_histories).select("practices.*, COUNT(diffusion_histories.*) as adoption_count").left_outer_joins(:categories).select("practices.*, categories.id as category_ids, categories.name as category_names").where(practices:{ approved: true, published: true, enabled: true }).group("practices.id, categories.id").uniq }
  scope :sort_a_to_z, -> { order(Arel.sql("lower(practices.name) ASC")) }
  scope :sort_adoptions_ct, -> { order(Arel.sql("adoption_count DESC, lower(practices.name) ASC")) }
  scope :sort_added, -> { order(Arel.sql("practices.created_at DESC")) }
  scope :filter_by_category_ids, -> (cat_ids) { where('category_practices.category_id IN (?)', cat_ids)} # cat_ids should be a id number or an array of id numbers

  belongs_to :user, optional: true

  has_many :additional_documents, -> { order(position: :asc) }, dependent: :destroy
  has_many :additional_resources, -> { order(position: :asc) }, dependent: :destroy
  has_many :additional_staffs, dependent: :destroy
  has_many :ancillary_service_practices, dependent: :destroy
  has_many :ancillary_services, through: :ancillary_service_practices
  has_many :badge_practices, dependent: :destroy
  has_many :badges, through: :badge_practices
  has_many :business_case_files, dependent: :destroy
  has_many :category_practices, -> { order(id: :asc) }, dependent: :destroy, autosave: true
  has_many :categories, -> { order(id: :asc) }, through: :category_practices
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
  has_many :impact_photos, -> { order(position: :asc) }, dependent: :destroy
  has_many :implementation_timeline_files, dependent: :destroy
  has_many :job_position_practices, dependent: :destroy
  has_many :job_positions, through: :job_position_practices
  has_many :photo_files, dependent: :destroy
  has_many :practice_management_practices, dependent: :destroy
  has_many :practice_managements, through: :practice_management_practices
  has_many :practice_partner_practices, dependent: :destroy
  has_many :practice_partners, through: :practice_partner_practices
  has_many :practice_permissions, -> { order(position: :asc) }, dependent: :destroy
  has_many :publications, -> { order(position: :asc) }, dependent: :destroy
  has_many :publication_files, dependent: :destroy
  has_many :required_staff_trainings, dependent: :destroy
  has_many :risk_mitigations, -> { order(position: :asc) }, dependent: :destroy
  has_many :survey_result_files, dependent: :destroy
  has_many :timelines, -> { order(position: :asc) }, dependent: :destroy
  has_many :toolkit_files, dependent: :destroy
  has_many :user_practices, dependent: :destroy
  has_many :users, through: :user_practices, dependent: :destroy
  has_many :va_employee_practices, dependent: :destroy
  has_many :va_employees, -> { order(position: :asc) }, through: :va_employee_practices
  has_many :va_secretary_priority_practices, dependent: :destroy
  has_many :va_secretary_priorities, through: :va_secretary_priority_practices
  has_many :video_files, -> { order(position: :asc) }, dependent: :destroy
  has_many :practice_creators, -> { order(position: :asc) }, dependent: :destroy
  has_many :practice_awards, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_origin_facilities, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_metrics, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_testimonials, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_multimedia, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_problem_resources, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_solution_resources, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_results_resources, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_emails, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_resources, -> {order(id: :asc) }, dependent: :destroy

  # This allows the practice model to be commented on with the use of the Commontator gem
  acts_as_commontable dependent: :destroy

  #accepts_nested_attributes_for :practices_origin_facilities?
  accepts_nested_attributes_for :practice_origin_facilities, allow_destroy: true, reject_if: proc { |attributes|
    attributes['facility_id'].blank?
  }
  accepts_nested_attributes_for :practice_metrics, allow_destroy: true, reject_if: proc { |attributes| attributes['description'].blank? }
  accepts_nested_attributes_for :practice_awards, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :categories, allow_destroy: true, reject_if: proc { true }
  accepts_nested_attributes_for :practice_partner_practices, allow_destroy: true
  accepts_nested_attributes_for :impact_photos, allow_destroy: true, reject_if: proc { |attributes|
    reject = attributes['description'].blank?
    ip_reject = false
    ip_reject = attributes['attachment'].blank? if attributes['id'].blank?
    reject || ip_reject
  }
  accepts_nested_attributes_for :practice_resources, allow_destroy: true, reject_if: proc { |attributes| attributes['resource'] && attributes['resource'].blank? }
  accepts_nested_attributes_for :practice_multimedia, allow_destroy: true
  accepts_nested_attributes_for :practice_testimonials, allow_destroy: true
  accepts_nested_attributes_for :practice_problem_resources, allow_destroy: true
  accepts_nested_attributes_for :practice_solution_resources, allow_destroy: true
  accepts_nested_attributes_for :practice_results_resources, allow_destroy: true
  accepts_nested_attributes_for :department_practices, allow_destroy: true, reject_if: proc { |attributes| attributes['value'].blank? }

  accepts_nested_attributes_for :video_files, allow_destroy: true, reject_if: proc { |attributes| attributes['url'].blank? || attributes['description'].blank? }
  accepts_nested_attributes_for :difficulties, allow_destroy: true
  accepts_nested_attributes_for :risk_mitigations, allow_destroy: true
  accepts_nested_attributes_for :timelines, allow_destroy: true, reject_if: proc{ |attributes| attributes['milestone'].blank? || attributes['timeline'].blank?}
  accepts_nested_attributes_for :va_employees, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? || attributes['role'].blank? }
  accepts_nested_attributes_for :additional_staffs, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? || attributes['hours_per_week'].blank? || attributes['duration_in_weeks'].blank? }
  accepts_nested_attributes_for :additional_resources, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :required_staff_trainings, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? || attributes['description'].blank? }
  accepts_nested_attributes_for :practice_creators, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? || attributes['role'].blank? }
  accepts_nested_attributes_for :practice_permissions, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :additional_documents, allow_destroy: true, reject_if: proc { |attributes|
    reject = attributes['title'].blank?
    ad_reject = false
    ad_reject = attributes['attachment'].blank? if attributes['id'].blank?
    reject || ad_reject
  }
  accepts_nested_attributes_for :publications, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? || attributes['link'].blank? }
  accepts_nested_attributes_for :practice_emails, allow_destroy: true, reject_if: proc { |attributes| attributes['address'].blank? }
  SATISFACTION_LABELS = ['Little or no impact', 'Some impact', 'Significant impact', 'High or large impact'].freeze
  COST_LABELS = ['0-$10,000', '$10,000-$50,000', '$50,000-$250,000', 'More than $250,000'].freeze
  # also known as "Difficulty"
  COMPLEXITY_LABELS = ['Little or no complexity', 'Some complexity', 'Significant complexity', 'High or large complexity'].freeze
  TIME_ESTIMATE_OPTIONS = ['1 week', '1 month', '3 months', '6 months', '1 year', 'longer than 1 year', 'Other (Please specify)']
  NUMBER_DEPARTMENTS_OPTIONS = ['1. Single department', '2. Two departments', '3. Three departments', '4. Four or more departments']
  def committed_user_count
    user_practices.where(committed: true).count
  end
  def committed_user_count_by_range(start_date, end_date)
    user_practices.where(time_committed: start_date...end_date).count
  end
  def number_of_adopted_facilities
    number_adopted
  end

  def number_of_completed_adoptions
    diffusion_histories.joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: 'Completed'}).or(diffusion_histories.joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: 'Implemented'})).or(diffusion_histories.joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: 'Complete'})).count
  end

  def number_of_in_progress_adoptions
    diffusion_histories.joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: 'In progress'}).or(diffusion_histories.joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: 'Planning'})).or(diffusion_histories.joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: 'Implementing'})).count
  end

  def number_of_unsuccessful_adoptions
    diffusion_histories.joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: 'Unsuccessful'}).count
  end

  def date_range_views(start_date, end_date)
    Ahoy::Event.where_props(practice_id: id).where(time: start_date...end_date).count
  end
  def favorited_count
    user_practices.where({favorited: true}).count
  end
  def favorited_count_by_range(start_date, end_date)
    user_practices.where({time_favorited: start_date...end_date}).count
  end
  def commits_count
    user_practices.where({committed: true}).count
  end
  def commits_count_by_range(start_date, end_date)
    user_practices.where({time_committed: start_date...end_date}).count
  end

  def get_adoptions_by_status(adoption_array, hash_array)
    vamc_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    adoption_array.each do |adoption|
      facility = vamc_facilities.find { |f| f['StationNumber'] == adoption.facility_id }
      hash_array.push(facility: facility, diffusion_history: adoption)
    end
    hash_array.sort_by { |a| [a[:facility]["StreetAddressState"], a[:facility]["OfficialStationName"]] }
  end
end