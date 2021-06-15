class DiffusionHistory < ApplicationRecord
  belongs_to :practice
  has_many :diffusion_history_statuses, dependent: :destroy
  after_save :clear_searchable_practices_cache
  after_destroy :clear_searchable_practices_cache

  attr_accessor :facility_name

  scope :with_published_enabled_approved_practices, -> { joins(:practice).where(practices: { published: true, enabled: true, approved: true }) }

  def facility_name
    facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    facility = facilities.find { |f| f['StationNumber'] == facility_id }
    facility['OfficialStationName']
  end

  def clear_searchable_practices_cache
    practice.clear_searchable_cache
  end
end
