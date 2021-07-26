# practice_origin_facilities related tasks
namespace :practice_origin_facilities do
  # rails practice_origin_facilities:move_practice_initiating_facility
  desc 'Move practice initiating facilities to the practice_origin_facilities table'
  task :move_practice_initiating_facility => :environment do
    initiating_facilities_practices = Practice.where(initiating_facility_type: 'facility')

    initiating_facilities_practices.each do |pr|
      if pr.initiating_facility.present?
        PracticeOriginFacility.find_or_create_by!(practice: pr, facility_id: pr.initiating_facility, facility_type: 0)
      end
    end
    puts "#{initiating_facilities_practices.length} practice origin facilities have been added"
  end

  desc 'Assign VA facility to each existing practice origin facility'
  task :assign_va_facility_to_practice_origin_facilities => :environment do
    no_facility_practice_origin_facilities = PracticeOriginFacility.where(va_facility_id: nil)

    if no_facility_practice_origin_facilities.any?
      no_facility_practice_origin_facilities.each do |pof|
        pof_facility = VaFacility.cached_va_facilities.find_by(station_number: pof.facility_id)
        if pof_facility.present?
          pof.update_attributes(va_facility_id: pof_facility.id)
          puts "PracticeOriginFacility #{pof.id} has been assigned a VA facility!"
        else
          puts "Error - PracticeOriginFacility #{pof.id} was not assigned a VA facility because #{pof.facility_id.nil? ? 'it\'s facility_id is nil.' : %Q(a VaFacility with the station_number '#{pof.facility_id}' does not exist.) }"
        end
      end
      puts "All practice origin facilities, which have a facility_id that corresponds to an existing VA facility's station_number, have been successfully updated!"
    else
      puts "All existing practice origin facilities are associated with a VA facility. No changes were made."
    end
  end
end
