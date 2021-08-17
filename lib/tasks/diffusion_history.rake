# Run these tasks to populate the geolocation sections of the application
namespace :diffusion_history do |diffusion_history_namespace|
  # rails diffusion_history:happen
  desc 'Create diffusion history for Project HAPPEN'
  task :happen => :environment do
    # find HAPPEN
    happen = Practice.find_by_slug('project-happen')

    load_practice_facilities_data(happen, 'HAPPEN_facility_data')
  end

  # rails diffusion_history:flow3
  desc 'Create diffusion history for FLOW3'
  task :flow3 => :environment do
    # find FLOW3
    flow3 = Practice.find_by_slug('flow3')

    load_practice_facilities_data(flow3, 'FLOW3_facility_data')
  end

  # rails diffusion_history:naloxone
  desc 'Create diffusion history for Rapid Naloxone'
  task :naloxone => :environment do
    # find Naloxone
    naloxone = Practice.find_by_slug('vha-rapid-naloxone')

    load_practice_facilities_data(naloxone, 'Rapid_Naloxone_facility_data')
  end

  # rails diffusion_history:telewound
  desc 'Create diffusion history for Telewound'
  task :telewound => :environment do
    # find Telewound
    telewound = Practice.find_by_slug('national-telewound-care-practice')

    load_practice_facilities_data(telewound, 'Telewound_facility_data')
  end

  # rails diffusion_history:vione
  desc 'Create diffusion history for VIONE'
  task :vione => :environment do
    # find VIONE
    vione = Practice.find_by_slug('vione')

    load_practice_facilities_data(vione, 'VIONE_facility_data')
  end

  desc 'Assign VA facility to each existing diffusion history'
  task :assign_va_facility_to_diffusion_histories => :environment do
    no_facility_diffusion_histories = DiffusionHistory.where(va_facility_id: nil)

    if no_facility_diffusion_histories.any?
      no_facility_diffusion_histories.each do |dh|
        dh_facility = VaFacility.find_by(station_number: dh.facility_id)
        if dh_facility.present?
          dh.update_attributes(va_facility_id: dh_facility.id)
          puts "DiffusionHistory #{dh.id} has been assigned a VA facility!"
        else
          puts "Error - DiffusionHistory #{dh.id} was not assigned a VA facility because #{dh.facility_id.nil? ? 'it\'s facility_id is nil.' : %Q(a VaFacility with the station_number #{dh.facility_id} does not exist.) }"
        end
      end
      puts "All diffusion histories that did not have an associated VA facility have been successfully updated with one!"
    else
      puts "All existing diffusion histories are associated with a VA facility. No changes were made."
    end
  end

  # rails diffusion_history:all
  desc 'Run all of the tasks within the diffusion_history namespace, except for assign_va_facility_to_diffusion_histories'
  task :all do
    diffusion_history_namespace.tasks.each do |task|
      Rake::Task[task].invoke unless task.name === 'diffusion_history:assign_va_facility_to_diffusion_histories'
    end
  end

  def load_practice_facilities_data(practice, data_file_name)
    puts "==> Importing Diffusion History for Practice: #{practice.name}...".light_blue
    # load vamc facility data
    facilities = VaFacility.all.get_relevant_attributes
    # load practice <-> facility json data
    practice_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/#{data_file_name}.json"))

    # create diffusion histories with matching facilities to practice's data
    practice_facilities.each do |pf|
      facility_id = facilities.find { |f| f.station_number === pf['StationNumber'] }.id
      status = if pf['Status'].present?
                 pf['Status'] == 'Planning' ? 'In progress' : 'Complete'
               else
                 'Complete'
               end
      start_time = DateTime.parse(pf['DateImplemented'])
      dh = DiffusionHistory.find_or_create_by!(practice: practice, va_facility_id: facility_id)
      DiffusionHistoryStatus.find_or_create_by!(diffusion_history: dh, status: status, start_time: start_time)
    end
    puts "==> Completed importing Diffusion History for Practice: #{practice.name}!".green
  end
end