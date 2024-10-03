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
      'Vendor link' => :vendor_link,
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

    # Check the csv origin column values for changes or additions
    PRACTICE_PARTNER_MAPPING = {
      "Spark-Seed-Spread" => "iNet Seed-Spark-Spread Innovation Investment Program",
      "Greenhouse" => "iNet Greenhouse Initiative",
      "Technology Transfer Program" => "VA Technology Transfer Program"
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
            filenames = (Dir.entries(folder_path) - %w[. ..]).sort # Get all files excluding '.' and '..'

            # Preload existing multimedia for the product to avoid repeated DB calls
            existing_multimedia = product.practice_multimedia.where(resource_type: 'image').pluck(:attachment_file_name).map(&:downcase)
            main_image_set = product.main_display_image_file_name&.downcase

            filenames.each do |filename|
              next unless filename.downcase.match?(/\.(jpg|jpeg|png)$/) # Check if it's an image

              file_path = Rails.root.join(folder_path, filename)

              # Check if this is the main image (ends in '0') and hasn't been set yet
              if filename.split('.')[0][-1] == '0'
                if main_image_set != filename.downcase
                  # Only set the main image if it's different from the current one
                  File.open(file_path) do |file|
                    product.main_display_image = file
                    product.main_display_image_alt_text = "add alt text"
                    product.save!
                  end
                  puts "#{filename} - main_display_image added" # Log only when a new image is added
                end
              else
                # Check if the non-main image is already associated with the product
                unless existing_multimedia.include?(filename.downcase)
                  pm = PracticeMultimedium.new(
                    name: "add caption",
                    resource_type: "image",
                    innovable: product,
                    image_alt_text: "add alt text"
                  )
                  pm.attachment = File.new(file_path)
                  pm.save!
                  puts "#{filename} - Multimedia - image added" # Log only when a new image is added
                end
              end
            end
          else
            puts "Image folder does not exist: #{folder_path}"
          end
        end
        puts "Created Product - #{product_name}"

        # Tags
        # Find or create all tags: 
        product_tags = {:Clinical=>
          ["Radiology",
           "Patient Comfort",
           "Ophthalmology",
           "Medication Management",
           "Amputee Care",
           "Nursing",
           "Physical Therapy",
           "Diabetes",
           "Dermatology",
           "Mobility"],
         :Operational=>
          ["Emergency Care",
           "Prosthetic and Sensory Aids",
           "Patient Education",
           "Rural Health",
           "Information Technology",
           "Inpatient Care",
           "Physical Equipment",
           "Patient Safety",
           "Access to Care",
           "Mobility"]
         }

        product_tags.each do |parent_cat, tags|
          parent_id = Category.find_by(name: parent_cat.to_s).id
          tags.each do |tag|
            Category.find_or_create_by(name: tag, parent_category_id: parent_id)
          end
        end



      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ActiveRecord::RecordNotSaved => e
        puts "Failed to process product: #{product_name}, Error: #{e.message}"
        raise ActiveRecord::Rollback
      end
    end

    puts 'All Products have been added to the DB!'
  end
end
