class Practice < Innovation
  include ActiveModel::Dirty
  include PracticeEditorUtils
  include VaEmail
  include ExtraSpaceRemover
  extend PracticeUtils

  before_validation :trim_whitespace
  after_create :create_practice_editor_for_practice
  after_commit :check_update_to_clear_cache

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

  def self.cached_json_practices(is_guest_user)
    if is_guest_user
      Rails.cache.fetch('searchable_public_practices_json', expires_in: 30.minutes) do
        practices = Practice.published_enabled_approved.includes(:practice_origin_facilities).public_facing.sort_by_retired
        practices_json(practices)
      end
    else
      Rails.cache.fetch('searchable_practices_json', expires_in: 30.minutes) do
        practices = Practice.published_enabled_approved.includes(:practice_origin_facilities).sort_by_retired
        practices_json(practices)
      end
    end
  end

  def self.cached_published_enabled_approved_practices
    Rails.cache.fetch('published_enabled_approved_practices', expires_in: 30.minutes) do
      Practice.published_enabled_approved
    end
  end

  def check_update_to_clear_cache
    important_attrs = [
      'name', 'tagline', 'description', 'summary', 'initiating_facility',
      'main_display_image_updated_at', 'published', 'enabled', 'approved',
      'date_initiated', 'maturity_level', 'overview_problem', 'overview_solution',
      'overview_results', 'retired', 'retired_reason', 'hidden', 'is_public'
    ]

    if saved_changes.keys.any? { |key| important_attrs.include?(key) }
      self.clear_searchable_cache
    end
  end

  def clear_searchable_cache
    cached_keys = [
      "searchable_practices_json",
      "searchable_public_practices_json",
      "s3_signer",
      "published_enabled_approved_practices",
      "#{cache_key}/as_json"
    ]

    cached_keys.each do |cached_key|
      Rails.cache.delete(cached_key)
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

  def current_month_views
    Ahoy::Event.practice_views_for_single_practice_by_date_range(id, Date.today.beginning_of_month, Date.today.end_of_month).count
  end

  # favorited
  def current_month_favorited
    favorited_count_by_range(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  def last_month_favorited
    favorited_count_by_range((Date.today - 1.months).beginning_of_month, (Date.today - 1.months).at_end_of_month)
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
          'introduction': 'editors',
          'adoptions': 'introduction',
          'overview': 'adoptions',
          'implementation': 'overview',
          'about': 'implementation'
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
        'Mission Daybreak Grand challenge winner',
        'Mission Daybreak Grand challenge finalist',
        'Mission Daybreak Grand challenge Promise Award recipient',
        'Other'
      ]

  MATURITY_LEVEL_MAP = {
      emerging: {
          link_text: 'emerging',
          description: 'This innovation is <b>emerging</b> and worth watching as it is being assessed in early implementations.'.html_safe,
          radio_button: 'Emerging and worth watching as it is being assessed in early implementations.'
      },
      replicate: {
          link_text: 'replicating',
          description: 'This innovation is <b>replicating</b> across multiple facilities as its impact continues to be validated.'.html_safe,
          radio_button: 'Replicating across multiple facilities as its impact continues to be validated.'
      },
      scale: {
          link_text: 'scaling',
          description: 'This innovation is <b>scaling</b> widely with the support of national stakeholders.'.html_safe,
          radio_button: 'Scaling widely with the support of national stakeholders.'
      }
  }


  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :origin_picture, content_type: /\Aimage\/.*\z/
  validates_uniqueness_of :name, {message: 'Innovation name already exists'}
  validates :user, presence: true, format: valid_va_email
  # validates_attachment_content_type :highlight_attachment, content_type: /\Aimage\/.*\z/

  scope :get_practice_owner_emails, -> {where.not(user_id: nil)}
  scope :with_categories_and_adoptions_ct, -> {
    published_enabled_approved
      .left_outer_joins(:categories)
      .left_outer_joins(:diffusion_histories)
      .group("practices.id")
      .select(
      "practices.*, " +
      "ARRAY_AGG(DISTINCT categories.name) category_names, " +
      "practices.diffusion_histories_count as adoption_count"
    )
  }
  scope :sort_a_to_z, -> { order(Arel.sql("lower(practices.name) ASC")) }
  scope :sort_adoptions_ct, -> { order(Arel.sql("diffusion_histories_count DESC, lower(practices.name) ASC")) }
  scope :sort_added, -> { order(Arel.sql("practices.created_at DESC")) }
  scope :filter_by_category_ids, -> (cat_ids) { where('category_practices.category_id IN (?)', cat_ids)} # cat_ids should be a id number or an array of id numbers
  scope :published_enabled_approved, -> { where(published: true, enabled: true, approved: true, hidden: false) }
  scope :sort_by_retired, -> { order("retired asc") }
  scope :get_by_adopted_facility, -> (facility_id) { left_outer_joins(:diffusion_histories).where(diffusion_histories: {va_facility_id: facility_id}).uniq }
  scope :get_by_adopted_facility_and_crh, -> (facility_id, crh_id) { left_outer_joins(:diffusion_histories).where(diffusion_histories: {va_facility_id: facility_id}).or(left_outer_joins(:diffusion_histories).where(diffusion_histories: {clinical_resource_hub_id: crh_id})).uniq }
  scope :get_by_adopted_crh, -> (crh_id) { left_outer_joins(:diffusion_histories).where(diffusion_histories: {clinical_resource_hub_id: crh_id}).uniq }

  scope :get_by_created_facility, -> (facility_id) { where(initiating_facility_type: 'facility').joins(:practice_origin_facilities).where(practice_origin_facilities: { va_facility_id: facility_id }).uniq }
  scope :get_by_created_facility_and_crh, -> (facility_id, crh_id) { where(initiating_facility_type: 'facility').joins(:practice_origin_facilities).where(practice_origin_facilities: { va_facility_id: facility_id }).or(where(initiating_facility_type: 'facility').joins(:practice_origin_facilities).where(practice_origin_facilities: { clinical_resource_hub_id: crh_id })).uniq }
  scope :get_by_created_crh, -> (crh_id) { where(practice_origin_facilities: { clinical_resource_hub_id: crh_id }).uniq }

  scope :load_associations, -> { includes(:categories, :diffusion_histories, :practice_origin_facilities) }
  scope :public_facing, -> { published_enabled_approved.where(is_public: true) }
  scope :get_with_va_facility_diffusion_histories, -> { published_enabled_approved.sort_a_to_z.joins(:diffusion_histories).where(diffusion_histories: { clinical_resource_hub_id: nil }).uniq }

  scope :not_updated_since, ->(date) { where('practices.updated_at < ?', date.to_date.beginning_of_day) }
  scope :not_emailed_since, ->(date) {
    where('practices.last_email_date < ?', date.to_date.beginning_of_day)
    .or(where(last_email_date: nil))
  }

  ransacker :user_email do
    Arel.sql("users.email")
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "support_network_email", "user_email"]
  end

  def self.ransackable_scopes(auth_object = nil)
    ["not_updated_since", "not_emailed_since"]
  end

  belongs_to :user, optional: true

  has_many :additional_documents, -> { order(position: :asc) }, dependent: :destroy
  has_many :additional_resources, -> { order(position: :asc) }, dependent: :destroy
  has_many :additional_staffs, dependent: :destroy
  has_many :ancillary_service_practices, dependent: :destroy
  has_many :ancillary_services, through: :ancillary_service_practices
  has_many :clinical_condition_practices, dependent: :destroy
  has_many :clinical_conditions, through: :clinical_condition_practices
  has_many :clinical_location_practices, dependent: :destroy
  has_many :clinical_locations, through: :clinical_location_practices 
  has_many :department_practices, dependent: :destroy
  has_many :departments, through: :department_practices
  has_many :developing_facility_type_practices, dependent: :destroy
  has_many :developing_facility_types, through: :developing_facility_type_practices
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
  has_many :practice_permissions, -> { order(position: :asc) }, dependent: :destroy
  has_many :publications, -> { order(position: :asc) }, dependent: :destroy
  has_many :risk_mitigations, -> { order(position: :asc) }, dependent: :destroy
  has_many :survey_result_files, dependent: :destroy
  has_many :timelines, -> { order(position: :asc) }, dependent: :destroy
  has_many :user_practices, dependent: :destroy
  has_many :users, through: :user_practices, dependent: :destroy
  has_many :va_secretary_priority_practices, dependent: :destroy
  has_many :va_secretary_priorities, through: :va_secretary_priority_practices
  has_many :video_files, -> { order(position: :asc) }, dependent: :destroy
  has_many :practice_creators, -> { order(position: :asc) }, dependent: :destroy
  has_many :practice_awards, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_origin_facilities, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_metrics, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_testimonials, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_problem_resources, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_solution_resources, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_results_resources, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_emails, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_resources, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_editor_sessions, -> {order(id: :asc) }, dependent: :destroy
  has_many :practice_editors, -> {order(created_at: :asc) }, dependent: :destroy

  # This allows the practice model to be commented on with the use of the Commontator gem
  acts_as_commontable dependent: :destroy

  accepts_nested_attributes_for :practice_origin_facilities, allow_destroy: true, reject_if: proc { |attributes| attributes['facility_id'].blank? }
  accepts_nested_attributes_for :practice_metrics, allow_destroy: true, reject_if: proc { |attributes| attributes['description'].blank? }
  accepts_nested_attributes_for :practice_awards, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :categories, allow_destroy: true, reject_if: proc { true }
  accepts_nested_attributes_for :practice_partner_practices, allow_destroy: true, reject_if: proc { |attributes| attributes['practice_partner_id'].blank? }
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
  accepts_nested_attributes_for :risk_mitigations, allow_destroy: true
  accepts_nested_attributes_for :timelines, allow_destroy: true, reject_if: proc{ |attributes| attributes['milestone'].blank? || attributes['timeline'].blank?}
  accepts_nested_attributes_for :va_employees, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? || attributes['role'].blank? }
  accepts_nested_attributes_for :additional_staffs, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? || attributes['hours_per_week'].blank? || attributes['duration_in_weeks'].blank? }
  accepts_nested_attributes_for :additional_resources, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
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
  accepts_nested_attributes_for :practice_editors, allow_destroy: true, reject_if: proc { |attributes| attributes['email'].blank? }

  def committed_user_count
    user_practices.where(committed: true).count
  end

  def number_of_adopted_facilities
    number_adopted
  end

  def number_of_completed_adoptions
    diffusion_histories.get_by_successful_status.size
  end

  def number_of_in_progress_adoptions
    diffusion_histories.get_by_in_progress_status.size
  end

  def number_of_unsuccessful_adoptions
    diffusion_histories.get_by_unsuccessful_status.size
  end

  def favorited_count
    user_practices.where({favorited: true}).count
  end

  def favorited_count_by_range(start_date, end_date)
    user_practices.where({time_favorited: start_date...end_date}).count
  end

  def create_practice_editor_for_practice
    PracticeEditor.create_and_invite(self, self.user) unless is_user_an_editor_for_practice(self, self.user)
  end

  def self.search_practices(search_term = nil, sort = 'a_to_z', categories = nil, is_user_guest = true)
    query = with_categories_and_adoptions_ct.left_outer_joins(:practice_origin_facilities)

    if is_user_guest
      query = query.public_facing
    end

    if search_term
      search = get_query_for_search_term(search_term)
      query = query.where(search[:query], search[:params])
    end

    if categories
      query = query.filter_by_category_ids(categories)
    end

    if sort === 'a_to_z'
      query = query.sort_a_to_z
    elsif sort === 'adoptions'
      query = query.sort_adoptions_ct
    elsif sort === 'added'
      query = query.sort_added
    end
    query = query.sort_by_retired
    query.group("practices.id, categories.id, practice_origin_facilities.id").uniq
  end

  def self.get_facility_created_practices(facility_id, search_term = nil, sort = 'a_to_z', categories = nil, is_user_guest = true)
    practices = search_practices(search_term, sort, categories, is_user_guest)
    practices.select { |pr| pr.practice_origin_facilities.pluck(:va_facility_id).include?(facility_id) }
  end

  def self.get_facility_adopted_practices(facility_id, search_term = nil, categories = nil, is_user_guest = true)
    practices = search_practices(search_term, 'a_to_z', categories, is_user_guest)
    practices.select { |pr| pr.diffusion_histories.pluck(:va_facility_id).include?(facility_id) }
  end

  def self.get_query_for_search_term(search_term)
    search_term = search_term.lstrip.rstrip
    sanitized_search_term = ActiveRecord::Base.sanitize_sql_like(search_term)
    search_query = "practices.name ILIKE :search OR practices.tagline ILIKE :search OR practices.description ILIKE :search OR practices.summary ILIKE :search OR practices.overview_problem ILIKE :search OR practices.overview_solution ILIKE :search OR practices.overview_results ILIKE :search OR categories.name ILIKE :search OR array_to_string(categories.related_terms, ' ') ILIKE :search"
    search_params = { search: "%#{sanitized_search_term}%" }

    maturity_levels = { emerging: 0, replicate: 1, scale: 2 }
    mat_level = search_term.split.map {|st| maturity_levels[st.to_sym] || ''}
    mat_level.reject!(&:blank?)

    if mat_level.length > 0
      search_query = search_query + " OR (practices.maturity_level = :maturity_level)"
      search_params[:maturity_level] = mat_level
    end

    va_fac_matches = VaFacility.where("official_station_name ILIKE :search OR common_name ILIKE :search", search: "%#{sanitized_search_term}%").select("id")

    if va_fac_matches.length > 0
      facilities = va_fac_matches.map { |st| st.id }
      search_query = search_query + " OR diffusion_histories.va_facility_id IN (:facilities) OR practice_origin_facilities.va_facility_id IN (:facilities)"
      search_params[:facilities] = facilities
    end
    return { query: search_query, params: search_params }
  end

  def diffusion_history_status_by_facility(facility)
    diffusion_histories.find_by(va_facility_id: facility.id).diffusion_history_statuses.first
  end

  # add other practice attributes that need whitespace trimmed as needed
  def trim_whitespace
    strip_attributes(
      [
        self.name
      ]
    )
  end

  # reject the PracticeOriginFacility if the facility field is blank OR the practice already has a PracticeOriginFacility with the same va_facility_id
  def reject_practice_origin_facilities(attributes)
    attributes['va_facility_id'].blank? || self.practice_origin_facilities.where(va_facility_id: attributes['va_facility_id'].to_i).exists?
  end

  def get_search_fields
    [:id, :name, :short_name, :description, :tagline, :summary, :slug, :initiating_facility_type, :initiating_facility, :initiating_department_office_id, :overview_problem, :overview_solution, :overview_results, :maturity_level, :date_published, :retired, :is_public, :date_initiated, :created_at, :practice_pages_updated]
  end

  def get_category_names(categories)
    cat_names = []
    categories.each do |cat|
      cat_names.push(cat.name)
      unless cat.related_terms.empty?
        cat_names.concat(cat.related_terms)
      end
    end
    cat_names
  end

  def as_json(*)
    Rails.cache.fetch("#{cache_key}/as_json") do
      super(only: get_search_fields).merge(
        date_initiated: date_initiated? ? date_initiated.strftime("%B %Y") : '(start date unknown)',
        category_names: get_category_names(self.categories.not_none),
        initiating_facility_name: origin_display(self),
        practice_partner_names: practice_partners.pluck(:name),
        origin_facilities: practice_origin_facilities.get_va_facilities + practice_origin_facilities.get_clinical_resource_hubs,
        adoption_facilities: diffusion_histories.get_va_facilities + diffusion_histories.get_clinical_resource_hubs,
        adoption_count: diffusion_histories.size
      )
    end
  end
end
