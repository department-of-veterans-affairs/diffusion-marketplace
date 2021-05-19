class VaFacility < ApplicationRecord
  extend FriendlyId
  friendly_id :common_name, use: :slugged
  belongs_to :visn
  before_save :clear_va_facility_cache_on_save
  after_save :reset_va_facility_cache

  attr_accessor :reset_cached_va_facilities

  scope :get_by_visn, -> (visn) { cached_va_facilities.where(visn: visn) }
  scope :get_classification_counts, -> (facility_type) { where(classification: facility_type).size }
  scope :get_classifications, -> { pluck(:classification).uniq }
  scope :get_station_numbers, -> { pluck(:station_number) }
  scope :get_locations, -> { order(:street_address_state).pluck(:street_address_state).uniq }

  def self.get_types
    select(:fy17_parent_station_complexity_level).distinct.order(:fy17_parent_station_complexity_level)
  end

  def practices_created_count
    Practice.published_enabled_approved.get_by_created_facility(station_number).count
  end

  def practices_adopted_count
    Practice.published_enabled_approved.get_by_adopted_facility(station_number).count
  end

  def clear_va_facility_cache
    Rails.cache.delete('va_facilities')
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
      VaFacility.all
    end
  end
end

