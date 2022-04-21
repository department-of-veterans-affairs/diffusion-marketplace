class PracticeOriginFacility <  ApplicationRecord
  belongs_to :practice
  belongs_to :va_facility

  scope :get_va_facilities, -> { includes(:va_facility).pluck("va_facilities.station_number") }
end