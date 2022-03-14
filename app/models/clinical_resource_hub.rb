class ClinicalResourceHub < ApplicationRecord
  belongs_to :visn
  has_many :diffusion_histories, dependent: :destroy
  has_many :practice_origin_facilities, dependent: :destroy

  before_save :clear_clinical_resource_hubs_cache_on_save
  before_destroy :clear_clinical_resource_hubs_cache_on_destroy
  after_save :reset_clinical_resource_hubs_cache
  after_destroy :reset_clinical_resource_hubs_cache

  attr_accessor :reset_cached_clinical_resource_hubs

  scope :sort_by_visn_number, -> { includes(:visn).sort_by { |crh| crh.visn.number } }

  def to_param
    visn.number.to_s
  end

  def clear_clinical_resource_hubs_cache
    Rails.cache.delete('clinical_resource_hubs')
  end

  def reset_clinical_resource_hubs_cache
    clear_clinical_resource_hubs_cache if self.reset_cached_clinical_resource_hubs
  end

  def clear_clinical_resource_hubs_cache_on_save
    if self.changed?
      self.reset_cached_clinical_resource_hubs = true
    end
  end

  def clear_clinical_resource_hubs_cache_on_destroy
    self.reset_cached_clinical_resource_hubs = true
  end

  def self.cached_clinical_resource_hubs
    Rails.cache.fetch('clinical_resource_hubs') do
      ClinicalResourceHub.all
    end
  end

  def practices_created_by_crh_count
    PracticeOriginFacility.where(clinical_resource_hub_id: id).count
  end

  def crh_created_practices
    Practice.where(id: PracticeOriginFacility.select(:practice_id).where(clinical_resource_hub_id: id))
  end

  def practices_adopted_by_crh_count
    DiffusionHistory.where(clinical_resource_hub_id: id).count
  end

  def get_crh_adopted_practices( crh_id, options = { :is_user_guest => true })
    options[:is_user_guest] ? Practice.public_facing.load_associations.get_by_adopted_facility_and_crh(0, crh_id) :
        Practice.published_enabled_approved.load_associations.get_by_adopted_facility_and_crh(0, crh_id)
  end

  # def get_crh_created_practices(station_numbers, crh_id, options = { :is_user_guest => true })
  #   facility_created_practices = options[:is_user_guest] ? Practice.public_facing.load_associations.where(initiating_facility_type: 'facility').get_by_created_facility_and_crh(station_numbers, crh_id) :
  #                                    Practice.published_enabled_approved.load_associations.where(initiating_facility_type: 'facility').get_by_created_facility_and_crh(station_numbers, crh_id)
  #   visn_created_practices = options[:is_user_guest] ? Practice.public_facing.load_associations.where(initiating_facility_type: 'visn').where(initiating_facility: id.to_s) :
  #                                Practice.published_enabled_approved.load_associations.where(initiating_facility_type: 'visn').where(initiating_facility: id.to_s)
  #
  #   facility_created_practices + visn_created_practices
  # end

  def get_crh_created_practices(crh_id, search_term = nil, sort = 'a_to_z', categories = nil, is_user_guest = true)
    practices = Practice.search_practices(search_term, sort, categories, is_user_guest)
    practices.select { |pr| pr.practice_origin_facilities.where(clinical_resource_hub_id: crh_id)}
  end

  # def search_crh_practices(search_term = nil, sort = 'a_to_z', categories = nil, is_user_guest = true)
  #   query = with_categories_and_adoptions_ct.left_outer_joins(:practice_origin_facilities)
  #
  #   if is_user_guest
  #     query = query.public_facing
  #   end
  #
  #   if search_term
  #     search = get_query_for_search_term(search_term)
  #     query = query.where(search[:query], search[:params])
  #   end
  #
  #   if categories
  #     query = query.filter_by_category_ids(categories)
  #   end
  #
  #   if sort === 'a_to_z'
  #     query = query.sort_a_to_z
  #   elsif sort === 'adoptions'
  #     query = query.sort_adoptions_ct
  #   elsif sort === 'added'
  #     query = query.sort_added
  #   end
  #   query = query.sort_by_retired
  #   query.group("practices.id, categories.id, practice_origin_facilities.id").uniq
  # end


end