module VisnsHelper
  def get_adopted_practices_count_by_visn(visn)
    practices = Practice.where(approved: true, published: true, enabled: true)

    visn_adopted_practices = []
    practices.each do |p|
      Vamc.where(visn: visn).each do |vamc|
        p.diffusion_histories.each do |dh|
          visn_adopted_practices << dh.facility_id if dh.facility_id === vamc.station_number
        end
      end
    end
    visn_adopted_practices.count
  end

  def get_created_practices_count_by_visn(visn)
    practices = Practice.where(approved: true, published: true, enabled: true)

    visn_created_practices = []
    practices.each do |p|
      origin_facilities = p.practice_origin_facilities
      initiating_facility = p.initiating_facility
      if p.facility? && origin_facilities.any?
        Vamc.where(visn: visn).each do |vamc|
          origin_facilities.each do |of|
            visn_created_practices << { "vamc": of.facility_id } if of.facility_id === vamc.station_number
          end
        end
      elsif p.visn? && initiating_facility.present?
        visn_created_practices << { "visn": initiating_facility } if initiating_facility === visn.id.to_s
      end
    end
    visn_created_practices.count
  end
end