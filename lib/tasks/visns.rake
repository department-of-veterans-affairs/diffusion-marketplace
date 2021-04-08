namespace :visns do
  desc 'Create new VISN and VISN liaison records based on the data from the practice_origin_lookup.json file'

  @origin_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))

  task :create_visns_and_transfer_data => :environment do

    @origin_data["visns"].each do |v|
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

    puts "All VISNs have now been added to the DB!"
  end

  task :create_visn_liaisons_and_transfer_data => :environment do
    @origin_data["visns"].each do |v|
      v["liaisons"].each do |vl|
        VisnLiaison.create!(
          visn: Visn.find(v["id"]),
          first_name: vl["first_name"],
          last_name: vl["last_name"],
          email: vl["email"],
          primary: vl["primary"]
        )
      end
    end

    puts "All VISN liaisons have been added to the DB!"
  end
end