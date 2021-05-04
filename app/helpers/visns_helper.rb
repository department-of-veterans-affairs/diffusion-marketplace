module VisnsHelper
  include StatesHelper

  def get_adopted_practices_count_by_visn(visn)
    visn_adopted_practices = []
    Practice.published_enabled_approved.each do |p|
      visn.get_va_facilities.each do |vaf|
        p.diffusion_histories.each do |dh|
          visn_adopted_practices << dh.facility_id if dh.facility_id === vaf.station_number.to_s
        end
      end
    end
    visn_adopted_practices.count
  end

  def get_created_practices_count_by_visn(visn)
    visn_created_practices = []
    Practice.published_enabled_approved.each do |p|
      origin_facilities = p.practice_origin_facilities
      initiating_facility = p.initiating_facility
      # add practices that have practice_origin_facilities
      if p.facility? && origin_facilities.any?
        visn.get_va_facilities.each do |vaf|
          origin_facilities.each do |of|
            visn_created_practices << { "va_facility": of.facility_id } if of.facility_id === vaf.station_number.to_s
          end
        end
      # add practices that have an initiating_facility
      elsif p.visn? && initiating_facility.present?
        visn_created_practices << { "visn": initiating_facility } if initiating_facility === visn.id.to_s
      end
    end
    visn_created_practices.count
  end

  def get_facility_locations_by_visn(visn)
    visn_facility_locations = []

    # add facility locations to empty array
    visn.get_va_facilities.each do |vaf|
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

  def facility_type_counts_by_visn(visn)
    visn_facility_types_arr = []

    # add facility types to empty array
    visn.get_va_facilities.each do |vaf|
      facility_type = vaf.classification

      visn_facility_types_arr << facility_type
    end

    # return the counts for each facility type
    [
      facility_type_count(visn_facility_types_arr, 'Health Care Center (HCC)'),
      facility_type_count(visn_facility_types_arr, 'Multi-Specialty CBOC'),
      facility_type_count(visn_facility_types_arr, 'Other Outpatient Services (OOS)'),
      facility_type_count(visn_facility_types_arr, 'Primary Care CBOC'),
      facility_type_count(visn_facility_types_arr, 'Residential Care Site (MH RRTP/DRRTP) (Stand-Alone)'),
      facility_type_count(visn_facility_types_arr, 'Unclassified'),
      facility_type_count(visn_facility_types_arr, 'VA Medical Center (VAMC)')
    ]
  end

  def get_facility_type_text_by_visn(visn)
    facility_type_counts = facility_type_counts_by_visn(visn)

    # create an array of hashes for each facility type that contains their corresponding text and count
    visn_facility_types_hash_arr = []

    visn_facility_types_hash_arr << { "text": "#{facility_type_counts[0]} Health Care Center#{facility_type_counts[0] != 1 ? 's' : ''}", "count": facility_type_counts[0] } if facility_type_counts[0] > 0
    visn_facility_types_hash_arr << { "text": "#{facility_type_counts[1]} Multi-Specialty CBOC#{facility_type_counts[1] != 1 ? 's' : ''}", "count": facility_type_counts[1] } if facility_type_counts[1] > 0
    visn_facility_types_hash_arr << { "text": "#{facility_type_counts[2]} Other Outpatient Service facilit#{facility_type_counts[2] != 1 ? 'ies' : 'y'}", "count": facility_type_counts[2] } if facility_type_counts[2] > 0
    visn_facility_types_hash_arr << { "text": "#{facility_type_counts[3]} Primary Care CBOC#{facility_type_counts[3] != 1 ? 's' : ''}", "count": facility_type_counts[3] } if facility_type_counts[3] > 0
    visn_facility_types_hash_arr << { "text": "#{facility_type_counts[4]} Residential Care Site#{facility_type_counts[4] != 1 ? 's' : ''}", "count": facility_type_counts[4] } if facility_type_counts[4] > 0
    visn_facility_types_hash_arr << { "text": "#{facility_type_counts[5]} Unclassified facilit#{facility_type_counts[5] != 1 ? 'ies' : 'y'}", "count": facility_type_counts[5] } if facility_type_counts[5] > 0
    visn_facility_types_hash_arr << { "text": "#{facility_type_counts[6]} VA Medical Center#{facility_type_counts[6] != 1 ? 's' : ''}", "count": facility_type_counts[6] } if facility_type_counts[6] > 0

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

  def get_facility_types_by_visn(visn)
    visn_facility_types = []

    # add facility types to empty array
    visn.get_va_facilities.each do |vaf|
      facility_type = vaf.classification

      visn_facility_types << facility_type unless visn_facility_types.include?(facility_type)
    end

    visn_facility_types
  end
end