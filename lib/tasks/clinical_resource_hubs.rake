namespace :clinical_resource_hubs do
  desc 'Create new Clinical_Resource_Hub records based on the data from the practice_origin_lookup.json file'

  @origin_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))

  task :create_clinical_resource_hubs => :environment do
    @origin_data["crh"].each do |v|
      visn = Visn.where(number: v["visn_number"]).first
      ClinicalResourceHub.create!(
          visn_id: visn.id,
          official_station_name: v["name"]
      )
    end
    puts "All Clinical Resource Hubs have been added to the DB!"
  end
end