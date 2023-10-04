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

  def get_crh_adopted_practices( crh_id, options = { is_user_guest: true })
    options[:is_user_guest] ? Practice.public_facing.load_associations.get_by_adopted_crh(crh_id) :
        Practice.published_enabled_approved.load_associations.get_by_adopted_crh(crh_id)
  end

  def get_crh_created_practices(crh_id, options = { is_user_guest: true })
    options[:is_user_guest] ? Practice.public_facing.load_associations.get_by_created_crh(crh_id) :
        Practice.published_enabled_approved.load_associations.get_by_created_crh(crh_id)
  end
end
