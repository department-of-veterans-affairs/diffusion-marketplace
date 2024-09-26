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
      'Description' => :description,
      'Innovators' => :innovators,
      'slug' => :slug,
      'Video URL' => :video_url,
      'Video Caption' => :video_caption
    }

    # Check the csv origin column values for changes or additions
    PRACTICE_PARTNER_MAPPING = {
      'Spark-Seed-Spread' => 'iNet Seed-Spark-Spread Innovation Investment Program',
      'Greenhouse' => 'iNet Greenhouse Initiative',
      'Technology Transfer Program' => 'VA Technology Transfer Program'
    }

    CSV.foreach(csv_file_path, headers: true) do |row|
      product_name = row['Name']

      begin
        ActiveRecord::Base.transaction do
          product_attributes = row.to_hash.transform_keys { |key| COLUMN_MAPPING[key.strip] }.compact
          origin = product_attributes.delete(:origin)
          innovators = product_attributes.delete(:innovators)
          slug = product_attributes.delete(:slug)
          video_url = product_attributes.delete(:video_url)
          video_caption = product_attributes.delete(:video_caption)


          product_attributes.each do |key, value|
            product_attributes[key] = nil if value == 'N/A' || value == ''
          end

          product = Product.find_or_initialize_by(name: product_attributes[:name])
          product.assign_attributes(product_attributes)

          user_changed = false
          if product.user.blank?
            product.user = User.find_by(email: "marketplace@va.gov")
            user_changed = true
          end

          product.save! if product.changed? || user_changed

          if PRACTICE_PARTNER_MAPPING[origin]
            practice_partner = PracticePartner.find_or_create_by!(name: PRACTICE_PARTNER_MAPPING[origin])
            PracticePartnerPractice.find_or_create_by!(innovable: product, practice_partner: practice_partner)
          end

          vha_practice_partner = PracticePartner.find_or_create_by!(slug: 'vha-innovators-network')
          PracticePartnerPractice.find_or_create_by!(innovable: product, practice_partner: vha_practice_partner)

          if innovators
            innovator_data = innovators.split("\n\n").map do |set|
              name, role = set.split("\n")
              { name: name.strip, role: role.strip }
            end

            innovator_data.each do |innovator_datum|
              va_employee = VaEmployee.find_or_create_by!(name: innovator_datum[:name], role: innovator_datum[:role])
              VaEmployeePractice.find_or_create_by!(va_employee: va_employee, innovable: product)
            end
          end

          # Multimedia - Video
          if video_url
            PracticeMultimedium.find_or_create_by(
              link_url: video_url,
              name: video_caption,
              resource_type: "video",
              innovable: product
            )
          end

          # Multimedia - Images
          folder_path = Rails.root.join('lib', 'assets', 'product-photos', slug)
          if Dir.exist?(folder_path)
            puts "Folder exists: #{folder_path}"
            filenames = (Dir.entries(folder_path) - %w[. ..]).sort # Get all files excluding '.' and '..'
            filenames.each do |filename|
              next unless filename.downcase.match?(/\.(jpg|jpeg|png)$/) # check it's an image
              file_path = Rails.root.join(folder_path, filename)
              if filename.split('.')[0][-1] == 0.to_s # use first image as main display image
                file = File.open(file_path)
                product.main_display_image = file
                file.close
                product.main_display_image_alt_text = "add alt text"
                product.save!
                puts filename + " - main_display_image"
              else
                PracticeMultimedium.create(
                  name: "add caption",
                  resource_type: "image",
                  innovable: product,
                  attachment_file_name: filename,
                  image_alt_text: "add alt text",
                  attachment: File.new(file_path)
                )
                puts filename + " - Multimedia - image"
              end
            end
          else
            puts "Image folder does not exist: #{folder_path}"
          end
        end
        puts "Created Product - #{product_name}"

      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ActiveRecord::RecordNotSaved => e
        puts "Failed to process product: #{product_name}, Error: #{e.message}"
        raise ActiveRecord::Rollback
      end
    end

    puts 'All Products have been added to the DB!'
  end
end
