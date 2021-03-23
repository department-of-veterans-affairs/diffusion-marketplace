module VisnsHelper
  include StatesHelper
  def get_adopted_practices_count_by_visn(visn)
    practices = Practice.where(approved: true, published: true, enabled: true)

    visn_adopted_practices = []
    practices.each do |p|
      VaFacility.cached_va_facilities.where(visn: visn).each do |vaf|
        p.diffusion_histories.each do |dh|
          visn_adopted_practices << dh.facility_id if dh.facility_id === vaf.station_number
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
        VaFacility.cached_va_facilities.where(visn: visn).each do |vaf|
          origin_facilities.each do |of|
            visn_created_practices << { "va_facility": of.facility_id } if of.facility_id === vaf.station_number
          end
        end
      elsif p.visn? && initiating_facility.present?
        visn_created_practices << { "visn": initiating_facility } if initiating_facility === visn.id.to_s
      end
    end
    visn_created_practices.count
  end

  def get_facility_locations_by_visn(visn)
    visn_facility_locations = []

    # add facility locations to empty array
    Vamc.cached_vamcs.where(visn: visn).each do |vamc|
      facility_location = vamc.street_address_state

      visn_facility_locations << facility_location unless visn_facility_locations.include?(facility_location)
    end

    location_list = ''
    # sort the locations alphabetically
    sorted_facility_locations = visn_facility_locations.sort

    # Add other US territories to us_states helper method array
    va_facility_locations = us_states.concat(
      [
       ["Virgin Islands", "VI"],
       ["Philippines Islands", "PI"],
       ["Guam", "GU"],
       ["American Samoa", "AS"]
      ]
    )

    # iterate through the facility locations and add text
    sorted_facility_locations.each do |fs|
      va_facility_locations.each do |vfl|
        full_name = vfl.first === "Virgin Islands" || vfl.first === "Philippines Islands" ? "the #{vfl.first}" : vfl.first
        if vfl[1] === fs
          if sorted_facility_locations.count > 1 && sorted_facility_locations.last === fs
            location_list += "and #{full_name}"
          elsif sorted_facility_locations.count > 2
            location_list += "#{full_name}, "
          else
            location_list += "#{full_name} "
          end
        end
      end
    end

    location_list
  end
end