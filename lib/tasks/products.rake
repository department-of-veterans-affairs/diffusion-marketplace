namespace :products do
  desc 'Create new products records based on the data from the products.json file'

  task :create_or_update_products => :environment do
    require 'csv'

    csv_file_path = 'lib/assets/products.csv'

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

    CSV.foreach(csv_file_path, headers: true) do |row|
      product_attributes = row.to_hash.transform_keys { |key| COLUMN_MAPPING[key.strip] }.compact

      product_attributes.each do |key, value|
        if value == "N/A"
          product_attributes[key] = nil
        elsif value.is_a?(String)
          product_attributes[key] = value.gsub(/""/, "'")
          product_attributes[key] = product_attributes[key].gsub(/\A\\?\"|\\?\"\z/, '').strip
        end
      end

      product = Product.find_or_initialize_by(id: product_attributes[:id])
      product.update!(product_attributes)

      puts "Created Product - #{product.name}"
    end

    puts "All Products have been added to the DB!"
  end
end
