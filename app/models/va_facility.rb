class VaFacility < ApplicationRecord
  extend FriendlyId
  friendly_id :common_name, use: :slugged
  belongs_to :visn
  has_many :diffusion_histories
  before_save :clear_va_facility_cache_on_save
  after_save :reset_va_facility_cache

  attr_accessor :reset_cached_va_facilities

  scope :get_by_visn, -> (visn) { cached_va_facilities.order_by_station_name.where(visn: visn) }
  scope :get_classification_counts, -> (facility_type) { where(classification: facility_type, hidden: false).size }
  scope :get_classifications, -> { pluck(:classification).uniq }
  scope :get_ids, -> { pluck(:id) }
  scope :get_locations, -> { order(:street_address_state).pluck(:street_address_state).uniq }
  scope :get_complexity, -> { order(:fy17_parent_station_complexity_level).pluck(:fy17_parent_station_complexity_level).uniq }
  scope :get_relevant_attributes, -> {
      select(:street_address_state, :official_station_name, :id, :visn_id, :common_name, :station_number, :latitude,
      :longitude, :slug, :fy17_parent_station_complexity_level, :rurality, :classification, :station_phone_number)
  }
  scope :order_by_station_name, -> { order(:official_station_name) }
  scope :order_by_state_and_station_name, -> { order(:street_address_state, :official_station_name) }

  def practices_created_count
    Practice.published_enabled_approved.get_by_created_facility(id).size
  end

  def practices_adopted_count
    Practice.published_enabled_approved.get_by_adopted_facility(id).size
  end

  def clear_va_facility_cache
    Cache.new.delete_cache_key('va_facilities')
  end

  def reset_va_facility_cache
    clear_va_facility_cache if self.reset_cached_va_facilities
  end

  def clear_va_facility_cache_on_save
    if self.changed?
      self.reset_cached_va_facilities = true
    end
  end

  def self.cached_va_facilities
    Rails.cache.fetch('va_facilities') do
      VaFacility.where(hidden: false).load
    end
  end
end

