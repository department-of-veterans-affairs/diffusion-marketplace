class Visn < ApplicationRecord
  include ActiveModel::Dirty
  has_many :va_facilities, dependent: :destroy
  has_one :clinical_resource_hub, dependent: :destroy
  has_many :visn_liaisons, dependent: :destroy

  before_save :clear_visn_cache_on_save
  after_save :reset_visn_cache

  attr_accessor :reset_cached_visns

  scope :order_by_number, -> { order('number') }
  scope :get_by_initiating_facility, -> (initiating_facility) { find_by(id: initiating_facility) }

  # Add a custom friendly URL that uses the visn number and not the id
  def to_param
    number.to_s
  end

  def clear_visn_cache
    Cache.new.delete_cache_key('visns')
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
      Visn.all.load
    end
  end

  def get_adopted_practices(station_numbers, crh_id, options = { :is_user_guest => true })
    options[:is_user_guest] ? Practice.public_facing.load_associations.get_by_adopted_facility_and_crh(station_numbers, crh_id) :
    Practice.published_enabled_approved.load_associations.get_by_adopted_facility_and_crh(station_numbers, crh_id)
  end

  def get_created_practices(station_numbers, crh_id, options = { :is_user_guest => true })
    facility_created_practices = options[:is_user_guest] ? Practice.public_facing.load_associations.where(initiating_facility_type: 'facility').get_by_created_facility_and_crh(station_numbers, crh_id) :
                                 Practice.published_enabled_approved.load_associations.where(initiating_facility_type: 'facility').get_by_created_facility_and_crh(station_numbers, crh_id)
    visn_created_practices = options[:is_user_guest] ? Practice.public_facing.load_associations.where(initiating_facility_type: 'visn').where(initiating_facility: id.to_s) :
                             Practice.published_enabled_approved.load_associations.where(initiating_facility_type: 'visn').where(initiating_facility: id.to_s)

    facility_created_practices + visn_created_practices
  end
end
