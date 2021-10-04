module VisnsHelper
  include StatesHelper

  def get_facility_locations_by_visn(visn)
    sorted_facility_locations = VaFacility.get_by_visn(visn).get_locations.sort
    location_list = ''
    
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

  def facility_type_counts_by_visn(visn)
    [
      VaFacility.get_by_visn(visn).get_classification_counts('Health Care Center (HCC)'),
      VaFacility.get_by_visn(visn).get_classification_counts('Multi-Specialty CBOC'),
      VaFacility.get_by_visn(visn).get_classification_counts('Other Outpatient Services (OOS)'),
      VaFacility.get_by_visn(visn).get_classification_counts('Primary Care CBOC'),
      VaFacility.get_by_visn(visn).get_classification_counts('Residential Care Site (MH RRTP/DRRTP) (Stand-Alone)'),
      VaFacility.get_by_visn(visn).get_classification_counts('Unclassified'),
      VaFacility.get_by_visn(visn).get_classification_counts('VA Medical Center (VAMC)')
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
    VaFacility.get_by_visn(visn).get_classifications
  end
end