module VaFacilitiesHelper

  def get_practices_created_count_by_va_facility(va_facility)
    Practice.joins(:practice_origin_facilities).where(published: true, enabled: true, approved: true, practice_origin_facilities: { facility_id: va_facility.station_number.to_s }).count
  end

  def get_practices_adopted_count_by_va_facility(va_facility)
    va_facility_adopted_practices = []
    Practice.published_enabled_approved.each do |p|
      p.diffusion_histories.each do |dh|
        va_facility_adopted_practices << p if dh.facility_id === va_facility.station_number.to_s
      end
    end
    va_facility_adopted_practices
  end
end