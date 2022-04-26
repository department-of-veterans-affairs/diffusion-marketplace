class DiffusionHistory < ApplicationRecord
  belongs_to :practice
  belongs_to :va_facility
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

  def clear_searchable_practices_cache
    practice.clear_searchable_cache
  end
end
