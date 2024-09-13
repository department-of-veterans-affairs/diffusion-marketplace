namespace :products do
  desc 'Create new products records based on the data from the products.json file'

  task :create_or_update_products => :environment do
    require 'csv'
    csv_file_path = 'lib/assets/products.csv'

    # Make sure the csv column names line up with the mapping values before running!!!
    COLUMN_MAPPING = {
      'Name' => :name,
      'Origin' => :origin,
      'Facility or Veteran Use' => :usage,
      'Item Number' => :item_number,
      'Price' => :price,
      'Vendor' => :vendor,
      'DUNS #' => :duns,
      'Shipping Estimate' => :shipping_timeline_estimate,
      'Meet the Intrapreneur' => :origin_story,
      'Description' => :description
    }

    # Check the csv origin column values for changes or additions
    PRACTICE_PARTNER_MAPPING = {
      "Spark-Seed-Spread" => "iNet Seed-Spark-Spread Innovation Investment Program",
      "Greenhouse" => "iNet Greenhouse Initiative",
      "Technology Transfer Program" => "VA Technology Transfer Program"
    }

    CSV.foreach(csv_file_path, headers: true) do |row|
      product_attributes = row.to_hash.transform_keys { |key| COLUMN_MAPPING[key.strip] }.compact
      origin = product_attributes.delete(:origin)

      product_attributes.each do |key, value|
        if value == "N/A"
          product_attributes[key] = nil
        elsif value.is_a?(String)
          product_attributes[key] = value.gsub(/""/, "'")
          product_attributes[key] = product_attributes[key].gsub(/\A\\?\"|\\?\"\z/, '').strip
        end
      end

      product = Product.find_or_initialize_by(name: product_attributes[:name])
      product.update!(product_attributes)

      if PRACTICE_PARTNER_MAPPING[origin]
        practice_partner = PracticePartner.find_or_initialize_by(name: PRACTICE_PARTNER_MAPPING[origin])
        PracticePartnerPractice.create!(innovable: product, practice_partner: practice_partner)
      end

      vha_practice_partner = PracticePartner.find_or_initialize_by(slug: "vha-innovators-network")
      PracticePartnerPractice.create!(innovable: product, practice_partner: vha_practice_partner)

      puts "Created Product - #{product.name}"
    end

    puts "All Products have been added to the DB!"
  end
end
