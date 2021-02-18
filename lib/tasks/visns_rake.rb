namespace :visns do
  desc 'Create new VISN records based on the data from the practice_origin_lookup.json file'

  task :create_visns_and_transfer_data => :environment do
    origin_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))

    debugger
  end
end