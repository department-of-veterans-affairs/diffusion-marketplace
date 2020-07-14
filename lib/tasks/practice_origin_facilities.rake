# practice_origin_facilities related tasks
namespace :practice_origin_facilities do
  # rails practice_origin_facilities:move_practice_initiating_facility
  desc 'Move practice.intitiating_facility to practice_origin_facilities table'
  task :move_practice_initiating_facility => :environment do
    initiating_facilities_practices = Practice.where.not(initiating_facility: nil)

    initiating_facilities_practices.each do |pr|
      PracticeOriginFacility.find_or_create_by!(practice: pr, facility_id: pr.initiating_facility, facility_type: 0) if pr.initiating_facility_type == 'facility'
    end
    puts "#{initiating_facilities_practices.length} practices have been assigned categories."
  end
end
