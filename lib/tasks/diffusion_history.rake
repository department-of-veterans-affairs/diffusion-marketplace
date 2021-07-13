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
    DiffusionHistory.where(va_facility_id: nil).each do |dh|
      dh_facility = dh.get_facility
      dh.update_attributes(va_facility_id: dh_facility.id)

      puts "Diffusion history (id: #{dh.id}) has been assigned a VA facility!"
    end
    puts "All diffusion histories that did not have an associated VA facility have now been successfully updated with one!"
  end

  # rails diffusion_history:all
  desc 'Run all of the tasks within the diffusion_history namespace'
  task :all do
    diffusion_history_namespace.tasks.each do |task|
      Rake::Task[task].invoke
    end
  end

  def load_practice_facilities_data(practice, data_file_name)
    puts "==> Importing Diffusion History for Practice: #{practice.name}...".light_blue
    # load vamc facility data
    facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    # load practice <-> facility json data
    practice_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/#{data_file_name}.json"))

    # create diffusion histories with matching facilities to practice's data
    practice_facilities.each do |pf|
      facility_id = facilities.find {|f| f['StationNumber'] == pf['StationNumber']}['StationNumber']
      status = if pf['Status'].present?
                 pf['Status'] == 'Planning' ? 'In progress' : 'Complete'
               else
                 'Complete'
               end
      start_time = DateTime.parse(pf['DateImplemented'])
      dh = DiffusionHistory.find_or_create_by!(practice: practice, facility_id: facility_id)
      DiffusionHistoryStatus.find_or_create_by!(diffusion_history: dh, status: status, start_time: start_time)
    end
    puts "==> Completed importing Diffusion History for Practice: #{practice.name}!".green
  end
end