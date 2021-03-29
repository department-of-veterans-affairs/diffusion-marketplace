module VaFacilitiesHelper
  include VisnsHelper

  def get_practices_created_count_by_va_facility(va_facility)
    va_facility_adopted_practices = []
    approved_published_enabled_practices.each do |p|
      p.diffusion_histories.each do |dh|
        va_facility_adopted_practices << dh.facility_id if dh.facility_id === va_facility.station_number
      end
    end
    va_facility_adopted_practices.count
  end

  def get_practices_adopted_count_by_va_facility(va_facility)
    va_facility_created_practices = []
    approved_published_enabled_practices.each do |p|
      origin_facilities = p.practice_origin_facilities
      if p.facility? && origin_facilities.any?
        origin_facilities.each do |of|
          va_facility_created_practices << of.facility_id if of.facility_id === va_facility.station_number
        end
      end
    end
    va_facility_created_practices.count
  end
end