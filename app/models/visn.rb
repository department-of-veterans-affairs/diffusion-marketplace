class Visn < ApplicationRecord
  has_many :va_facilities, dependent: :destroy
  has_many :visn_liaisons, dependent: :destroy

  before_save :clear_visn_cache_on_save
  after_save :reset_visn_cache

  attr_accessor :reset_cached_visns

  scope :order_by_number, -> { order('number') }

  # Add a custom friendly URL that uses the visn number and not the id
  def to_param
    number.to_s
  end

  def clear_visn_cache
    Rails.cache.delete('visns')
  end

  def reset_visn_cache
    clear_visn_cache if self.reset_cached_visns
  end

  def clear_visn_cache_on_save
    if self.changed?
      self.reset_cached_visns = true
    end
  end

  def self.cached_visns
    Rails.cache.fetch('visns') do
      Visn.all
    end
  end

  def get_adopted_practices(station_numbers)
    Practice.published_enabled_approved.load_associations.get_by_adopted_facility(station_numbers)
  end

  def get_created_practices(station_numbers)
    (Practice.published_enabled_approved.load_associations.where(initiating_facility_type: 'facility').get_by_created_facility(station_numbers)).or(Practice.published_enabled_approved.load_associations.joins(:practice_origin_facilities).where(initiating_facility_type: 'visn').where(initiating_facility: id.to_s))
  end
end
