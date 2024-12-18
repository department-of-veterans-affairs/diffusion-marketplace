namespace :visns do
  desc 'Create new VISN records based on the data from the practice_origin_lookup.json file'

  @origin_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))

  task :create_visns_and_transfer_data => :environment do

    @origin_data["visns"].each do |v|
      if Visn.where(number: v["number"].split('-').pop.to_i).empty?
        Visn.create!(
          name: v["name"],
          number: v["number"].split('-').pop.to_i,
          street_address: v["street_address"],
          city: v["city"],
          state: v["state"],
          zip_code: v["zip_code"],
          latitude: v["latitude"],
          longitude: v["longitude"],
          phone_number: v["phone_number"]
        )
      end
    end

    puts "All VISNs have now been added to the DB!"
  end
end