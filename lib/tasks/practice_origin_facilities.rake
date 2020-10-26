# practice_origin_facilities related tasks
namespace :practice_origin_facilities do
  # rails practice_origin_facilities:move_practice_initiating_facility
  desc 'Move practice initiating facilities to the practice_origin_facilities table'
  task :move_practice_initiating_facility => :environment do
    initiating_facilities_practices = Practice.where(initiating_facility_type: 'facility')

    initiating_facilities_practices.each do |pr|
      if (pr.initiating_facility.present?)
        PracticeOriginFacility.find_or_create_by!(practice: pr, facility_id: pr.initiating_facility, facility_type: 0)
      end
    end
    puts "#{initiating_facilities_practices.length} practice origin facilities have been added"
  end
end
