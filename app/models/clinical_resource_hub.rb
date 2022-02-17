class ClinicalResourceHub < ApplicationRecord
  belongs_to :visn
  has_many :diffusion_histories, dependent: :destroy
  has_many :practice_origin_facilities, dependent: :destroy

  before_save :clear_clinical_resource_hubs_cache_on_save
  before_destroy :clear_clinical_resource_hubs_cache_on_destroy
  after_save :reset_clinical_resource_hubs_cache
  after_destroy :reset_clinical_resource_hubs_cache

  attr_accessor :reset_cached_clinical_resource_hubs

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
end