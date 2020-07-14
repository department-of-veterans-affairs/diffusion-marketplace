# practice_origin_facilities related tasks
namespace :practice_origin_facilities do
  # rails practice_origin_facilities:move_practice_initiating_facility
  desc 'Move practice.intitiating_facility to practice_origin_facilities table'
  task :move_practice_initiating_facility => :environment do
    initiating_facilities_practices = Practice.where.not(initiating_facility: nil)

    initiating_facilities_practices.each do |pr|
      # find or create practice origin facility
      pof = PracticeOriginFacility.find_or_create_by!(practice: pr)

      # modify
      facility_types = {
        facility: 0,
        visn: 1,
        department: 2,
        other: 3
      }

      pof.update(facility_id: pr.initiating_facility, facility_type: facility_types[pr.initiating_facility_type.to_sym]) if pr.initiating_facility_type != 'department'
      pof.update(facility_id: pr.initiating_facility, facility_type: facility_types[pr.initiating_facility_type.to_sym], initiating_department_office_id: pr.initiating_department_office_id) if pr.initiating_facility_type == 'department'
    end
    puts "#{initiating_facilities_practices.length} practices have been assigned categories."
  end
end
