class DiffusionHistory < ApplicationRecord
  belongs_to :practice
  belongs_to :va_facility, optional: true
  belongs_to :clinical_resource_hub, optional: true


  validates_with DiffusionHistoryValidator, on: [:create, :update] # check CRH exists or facility exists


  has_many :diffusion_history_statuses, dependent: :destroy
  after_save :clear_searchable_practices_cache
  after_destroy :clear_searchable_practices_cache

  attr_accessor :facility_name

  scope :by_status, -> (status) { joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: status}) }
  scope :get_by_successful_status, -> { (by_status('Completed')).or(by_status('Implemented')).or(by_status('Complete')) }
  scope :get_by_in_progress_status, -> { (by_status('In progress')).or(by_status('Planning')).or(by_status('Implementing')) }
  scope :get_by_unsuccessful_status, -> { by_status('Unsuccessful') }
  scope :get_with_practices, -> (public_practice) { joins(:practice).includes([:practice]).where(practices: public_practice ? { published: true, enabled: true, approved: true, hidden: false, is_public: true } : { published: true, enabled: true, approved: true, hidden: false }).select("diffusion_histories.*, practices.id as practices_id") }
  scope :get_va_facilities, -> { includes(:va_facility).pluck("va_facilities.station_number") }
  scope :get_clinical_resource_hubs, -> { includes(:clinical_resource_hub).pluck("clinical_resource_hubs.official_station_name") }
  scope :get_with_practice, -> (practice) { joins(:practice).where(practice: practice) }
  scope :exclude_va_facilities, -> { where(va_facility_id: nil) }
  scope :exclude_clinical_resource_hubs, -> { where(clinical_resource_hub_id: nil) }

  def clear_searchable_practices_cache
    practice.clear_searchable_cache
  end
end
