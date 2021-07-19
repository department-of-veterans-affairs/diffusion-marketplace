class PracticeOriginFacility <  ApplicationRecord
  belongs_to :practice
  belongs_to :va_facility

  def get_facility
    VaFacility.cached_va_facilities.find_by(station_number: facility_id)
  end
end