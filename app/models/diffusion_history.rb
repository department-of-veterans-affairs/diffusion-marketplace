class DiffusionHistory < ApplicationRecord
  belongs_to :practice
  belongs_to :va_facility
  has_many :diffusion_history_statuses, dependent: :destroy
  after_save :clear_searchable_practices_cache
  after_destroy :clear_searchable_practices_cache

  attr_accessor :facility_name

  scope :with_published_enabled_approved_practices, -> { joins(:practice).where(practices: { published: true, enabled: true, approved: true }) }
  scope :by_status, -> (status) { joins(:diffusion_history_statuses).where(diffusion_history_statuses: {status: status}) }
  scope :get_by_successful_status, -> { (by_status('Completed')).or(by_status('Implemented')).or(by_status('Complete')) }
  scope :get_by_in_progress_status, -> { (by_status('In progress')).or(by_status('Planning')).or(by_status('Implementing')) }
  scope :get_by_unsuccessful_status, -> { by_status('Unsuccessful') }
  scope :get_with_practices, -> { joins(:practice).where(practices: { published: true, enabled: true, approved: true }).select("diffusion_histories.*, practices.id as practices_id") }

  def get_facility
    VaFacility.find_by(station_number: facility_id)
  end

  def clear_searchable_practices_cache
    practice.clear_searchable_cache
  end
end
