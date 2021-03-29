module VisnsHelper
  include StatesHelper

  def approved_published_enabled_practices
    Practice.where(approved: true, published: true, enabled: true)
  end

  def visn_va_facilities(visn)
    VaFacility.cached_va_facilities.where(visn: visn)
  end

  def get_adopted_practices_count_by_visn(visn)
    visn_adopted_practices = []
    approved_published_enabled_practices.each do |p|
      visn_va_facilities(visn).each do |vaf|
        p.diffusion_histories.each do |dh|
          visn_adopted_practices << dh.facility_id if dh.facility_id === vaf.station_number
        end
      end
    end
    visn_adopted_practices.count
  end

  def get_created_practices_count_by_visn(visn)
    visn_created_practices = []
    approved_published_enabled_practices.each do |p|
      origin_facilities = p.practice_origin_facilities
      initiating_facility = p.initiating_facility
      if p.facility? && origin_facilities.any?
        visn_va_facilities(visn).each do |vaf|
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
    visn_va_facilities(visn).each do |vaf|
      facility_location = vaf.street_address_state

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
    sorted_facility_locations.each do |sfl|
      va_facility_locations.each do |vfl|
        full_name = vfl.first === "Virgin Islands" || vfl.first === "Philippines Islands" ? "the #{vfl.first}" : vfl.first
        if vfl[1] === sfl
          if sorted_facility_locations.count > 1 && sorted_facility_locations.last === sfl
            location_list += "and #{full_name}"
          elsif sorted_facility_locations.count > 2
            location_list += "#{full_name}, "
          else
            location_list += sorted_facility_locations.count == 1 ? "#{full_name}" : "#{full_name} "
          end
        end
      end
    end

    location_list
  end

  def facility_type_count(facility_type_array, facility_type)
    facility_type_array.select { |type| type === facility_type }.count
  end

  def get_facility_types_and_counts_by_visn(visn)
    visn_facility_types_arr = []

    # add facility types to empty array
    visn_va_facilities(visn).each do |vaf|
      facility_type = vaf.classification

      visn_facility_types_arr << facility_type
    end

    # get the counts for each facility type
    hcc_count = facility_type_count(visn_facility_types_arr, 'Health Care Center (HCC)')
    multi_specialty_cboc_count = facility_type_count(visn_facility_types_arr, 'Multi-Specialty CBOC')
    oos_count = facility_type_count(visn_facility_types_arr, 'Other Outpatient Services (OOS)')
    primary_care_cboc_count = facility_type_count(visn_facility_types_arr, 'Primary Care CBOC')
    stand_alone_count = facility_type_count(visn_facility_types_arr, 'Residential Care Site (MH RRTP/DRRTP) (Stand-Alone)')
    unclassified_count = facility_type_count(visn_facility_types_arr, 'Unclassified')
    vamc_count = facility_type_count(visn_facility_types_arr, 'VA Medical Center (VAMC)')

    # create an array of hashes for each facility type that contains their corresponding text and count
    visn_facility_types_hash_arr = []

    visn_facility_types_hash_arr << { "text": "#{hcc_count} Health Care Center#{hcc_count != 1 ? 's' : ''}", "count": hcc_count } if hcc_count > 0
    visn_facility_types_hash_arr << { "text": "#{multi_specialty_cboc_count} Multi-Specialty CBOC#{multi_specialty_cboc_count != 1 ? 's' : ''}", "count": multi_specialty_cboc_count } if multi_specialty_cboc_count > 0
    visn_facility_types_hash_arr << { "text": "#{oos_count} Other Outpatient Service facilit#{oos_count != 1 ? 'ies' : 'y'}", "count": oos_count } if oos_count > 0
    visn_facility_types_hash_arr << { "text": "#{primary_care_cboc_count} Primary Care CBOC#{primary_care_cboc_count != 1 ? 's' : ''}", "count": primary_care_cboc_count } if primary_care_cboc_count > 0
    visn_facility_types_hash_arr << { "text": "#{stand_alone_count} Residential Care Site#{stand_alone_count != 1 ? 's' : ''}", "count": stand_alone_count } if stand_alone_count > 0
    visn_facility_types_hash_arr << { "text": "#{unclassified_count} Unclassified facilit#{unclassified_count != 1 ? 'ies' : 'y'}", "count": unclassified_count } if unclassified_count > 0
    visn_facility_types_hash_arr << { "text": "#{vamc_count} VA Medical Center#{vamc_count != 1 ? 's' : ''}", "count": vamc_count } if vamc_count > 0

    # sort the facility types by count and then add punctuation where necessary
    sorted_facility_types_hash_arr = visn_facility_types_hash_arr.sort_by { |c| -c[:count] }
    final_facility_type_text = sorted_facility_types_hash_arr.count >= 2 ? sorted_facility_types_hash_arr.last[:text].insert(0, 'and ') : nil
    if sorted_facility_types_hash_arr.count > 2
      sorted_facility_types_hash_arr[0..-2].each { |f| f[:text].insert(-1, ', ') }
      final_facility_type_text
    elsif sorted_facility_types_hash_arr.count == 2
      sorted_facility_types_hash_arr.first[:text].insert(-1, ' ')
      final_facility_type_text
    end

    # add each sorted facility type with text and count to a string to display in the view
    visn_facility_types_text_and_count_str = ''
    sorted_facility_types_hash_arr.each do |facility_hash|
      visn_facility_types_text_and_count_str += facility_hash[:text]
    end

    visn_facility_types_text_and_count_str
  end
end