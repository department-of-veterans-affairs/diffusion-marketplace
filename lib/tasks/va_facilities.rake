namespace :va_facilities do
  desc 'Create new VA facility records based on the data from the va_facilities.json file'

  task :create_or_update_va_facilities => :environment do
    current_facility_ids = []
    ctr = 0
    file = File.read("#{Rails.root}/lib/assets/va_facilities.json")
    va_facilities = JSON.parse(file)
    visns_by_number = Visn.all.index_by(&:number)
    facilities_with_blank_street_address = []

    va_facilities.each do |vaf|
      # skip facility data with no street address
      if vaf["Street Address"].blank?
        facilities_with_blank_street_address << vaf["Official Station Name"]
        next
      end

      visn = visns_by_number[vaf["VISN"].to_i]
      if visn
        facility = VaFacility.find_by(visn: visn, station_number: vaf["Station Number"])
        classification = vaf["Classification"].blank? ? "Unclassified" : vaf["Classification"]

        if facility.nil?
          puts 'Creating facility - ' + vaf["Official Station Name"]
            hidden = vaf["Classification"].blank?
            facility = VaFacility.create!(
                visn: visn,
                sta3n: vaf["STA3N (For Sorting)"].to_s,
                station_number: vaf["Station Number"].to_s,
                official_station_name: vaf["Official Station Name"],
                common_name: vaf["Location Descriptive Name (Common Name)"],
                classification: classification,
                classification_status: vaf["Classification\nStatus (Firm \/ Conditional \/ Save Rating \/ By Appeal)"],
                mobile: vaf["Mobile"],
                parent_station_number: vaf["Official Parent Station Number"].to_s,
                official_parent_station_name: vaf["Official Parent Station Name"],
                fy17_parent_station_complexity_level: vaf["FY23 Parent Station Complexity Level"],
                operational_status: vaf["Operational Status: \nActive (A) or Planned (P) or Temporarily Deactivated (T) Permanently Deactivated (D)"],
                ownership_type: vaf["Ownership Type"],
                delivery_mechanism: vaf["Delivery\nMechanism"],
                staffing_type: vaf["Staffing\nType"],

                # these 3 not in VetCenter json schema...
                va_secretary_10n_approved_date: vaf["VA Secretary \/ 10N Approved Date"],
                planned_activation_date: vaf["Planned Activation Date"],
                station_number_suffix_reservation_effective_date: vaf["Station Number Suffix Reservation Effective Date"],


                operational_date: vaf["Operational Date"],
                date_of_first_workload: vaf["Date Of First Workload"],
                points_of_service: vaf["Points of Service"].to_s,
                street_address: vaf["Street Address"],
                street_address_city: vaf["Street Address-City"],
                street_address_state: vaf["Street Address-State"],
                street_address_zip_code: vaf["Street Address-Zip Code"].to_s,
                street_address_zip_code_extension: vaf["Street Address-Zip Code Extension"].to_s,
                county_street_address: vaf["Street Address-County"],
                mailing_address: vaf["Mailing Address"],
                mailing_address_city: vaf["Mailing Address-City"],
                mailing_address_state: vaf["Mailing Address-State"],
                mailing_address_zip_code: vaf["Mailing Address-Zip Code"].to_s,
                mailing_address_zip_code_extension: vaf["Mailing Address-Zip Code Extension"].to_s,
                county_mailing_address: vaf["Mailing Address-County"],
                station_phone_number: vaf["Main Phone + extension:"],
                station_main_fax_number: vaf["Fax Phone + extension:"],

                # these 4 not in VetCenter json schema...
                after_hours_phone_number: vaf["After Hours Phone + extension:"],
                pharmacy_phone_number: vaf["Pharmacy Phone + extension:"],
                enrollment_coordinator_phone_number: vaf["Enrollment Coordinator Phone + extension:"],
                patient_advocate_phone_number: vaf["Patient Advocate Phone + extension:"],

                latitude: vaf["Latitude"].to_f,
                longitude: vaf["Longitude"].to_f,
                congressional_district: vaf["Congressional District"],
                market: vaf["Market"],
                sub_market: vaf["Submarket"],
                sector: vaf["Sector"],
                fips_code: vaf["FIPS Code"].to_s,
                rurality: vaf["Rurality: U=Urban; R=Rural; H=Highly ruralI=Insular"],
                monday: vaf["Operational\nHours\nMonday"],
                tuesday: vaf["Operational\nHours\nTuesday"],
                wednesday: vaf["Operational\nHours\nWednesday"],
                thursday: vaf["Operational\nHours\nThursday"],
                friday: vaf["Operational\nHours\nFriday"],
                saturday: vaf["Operational\nHours\nSaturday"],
                sunday: vaf["Operational\nHours\nSunday"],
                hours_note: vaf["Operational Hours\nAdditional Information\n(Optional)\n"],
                hidden: hidden
            )
        elsif facility.present?
          # update record.....
          facility.visn = visn
          facility.sta3n = vaf["STA3N (For Sorting)"].to_s
          facility.station_number = vaf["Station Number"].to_s
          facility.official_station_name = vaf["Official Station Name"]
          facility.common_name = vaf["Location Descriptive Name (Common Name)"]
          facility.classification = classification
          facility.classification_status = vaf["Classification\nStatus (Firm \/ Conditional \/ Save Rating \/ By Appeal)"]
          facility.mobile = vaf["Mobile"]
          facility.parent_station_number = vaf["Parent Station Number"].to_s
          facility.official_parent_station_name = vaf["Official Parent Station Name"]
          facility.fy17_parent_station_complexity_level = vaf["FY23 Parent Station Complexity Level"]
          facility.operational_status = vaf["Operational Status: \nActive (A) or Planned (P) or Temporarily Deactivated (T) Permanently Deactivated (D)"]
          facility.ownership_type = vaf["Ownership Type"]
          facility.delivery_mechanism = vaf["Delivery\nMechanism"]
          facility.staffing_type = vaf["StaffingType"]
          facility.operational_date = vaf["Operational Date"]
          facility.date_of_first_workload = vaf["Date Of First Workload"]
          facility.points_of_service = vaf["Points of Service"].to_s
          facility.street_address = vaf["Street Address"]
          facility.street_address_city = vaf["Street Address-City"]
          facility.street_address_state = vaf["Street Address-State"]
          facility.street_address_zip_code = vaf["Street Address-Zip Code"].to_s
          facility.street_address_zip_code_extension = vaf["Street Address-Zip Code Extension"].to_s
          facility.county_street_address = vaf["Street Address-County"]
          facility.mailing_address = vaf["Mailing Address"]
          facility.mailing_address_city = vaf["Mailing Address-City"]
          facility.mailing_address_state = vaf["Mailing Address-State"]
          facility.mailing_address_zip_code = vaf["Mailing Address-Zip Code"].to_s
          facility.mailing_address_zip_code_extension = vaf["Mailing Address-Zip Code Extension"].to_s
          facility.county_mailing_address = vaf["Mailing Address-County"]
          facility.station_phone_number = vaf["Main Phone + extension:"]
          facility.station_main_fax_number = vaf["Fax Phone + extension:"]

          #these 7 not in Vet Center schema...
          unless vaf["Official Station Name"].include?("Vet Center")
            facility.after_hours_phone_number = vaf["After Hours Phone + extension:"]
            facility.pharmacy_phone_number = vaf["Pharmacy Phone + extension:"]
            facility.enrollment_coordinator_phone_number = vaf["Enrollment Coordinator Phone + extension:"]
            facility.patient_advocate_phone_number = vaf["Patient Advocate Phone + extension:"]
            facility.va_secretary_10n_approved_date = vaf["VA Secretary \/ 10N Approved Date"]
            facility.planned_activation_date = vaf["Planned Activation Date"]
            facility.station_number_suffix_reservation_effective_date = vaf["Station Number Suffix Reservation Effective Date"]
          end
          facility.latitude = vaf["Latitude"].to_f
          facility.longitude = vaf["Longitude"].to_f
          facility.congressional_district = vaf["Congressional District"]
          facility.market = vaf["Market"]
          facility.sub_market = vaf["Submarket"]
          facility.sector = vaf["Sector"]
          facility.fips_code = vaf["FIPS Code"].to_s
          facility.rurality = vaf["Rurality: U=Urban; R=Rural; H=Highly ruralI=Insular"]
          facility.monday = vaf["Operational\nHours\nMonday"]
          facility.tuesday = vaf["Operational\nHours\nTuesday"]
          facility.wednesday = vaf["Operational\nHours\nWednesday"]
          facility.thursday = vaf["Operational\nHours\nThursday"]
          facility.friday = vaf["Operational\nHours\nFriday"]
          facility.saturday = vaf["Operational\nHours\nSaturday"]
          facility.sunday = vaf["Operational\nHours\nSunday"]
          facility.hours_note = vaf["Operational Hours\nAdditional Information\n(Optional)\n"]
          facility.save
          ctr += 1
          puts "Updated facility: #{vaf['Official Station Name']}, #{ctr.to_s}"
        end
        current_facility_ids << facility.id if facility&.persisted?
      end
    end

      non_current_facilities = VaFacility.where.not(id: current_facility_ids).pluck(:official_station_name, :id).to_h
      if non_current_facilities.present?
        current_date = Date.today.strftime("%Y-%m-%d")
        filename = "#{Rails.root}/lib/assets/non_current_facility_ids_#{current_date}.json"

        File.open(filename, "w") do |file|
          file.write(non_current_facilities.to_json)
        end

        non_current_facilities_message = "#{non_current_facilities.count} Non-current facility names and IDs saved to #{filename}."
      else
        non_current_facilities_message = "No non-current facilities were found"
      end

      if facilities_with_blank_street_address.any?
        blank_street_message =  "#{facilities_with_blank_street_address.count} facilities with blank 'Street Address' were found in the input data:#{facilities_with_blank_street_address}"
      else
        blank_street_message = "No facilities with blank 'Street Address' were found in the input data."
      end
    puts "All VA facilities have been created or updated in the DB!"
    puts non_current_facilities_message
    puts blank_street_message
  end

  task :delete_non_current_va_facilities => :environment do
    current_date = Date.today.strftime("%Y-%m-%d")
    file_path = "#{Rails.root}/lib/assets/non_current_facility_ids_#{current_date}.json"
    output_file = "#{Rails.root}/lib/assets/deleted_and_non_deleted_facilities_#{current_date}.json"

    if File.exist?(file_path)
      non_current_facilities = JSON.parse(File.read(file_path))
      deleted_facilities = {}
      non_deleted_facilities = {}
      deletion_count = 0

      non_current_facilities.each do |name, id|
        facility = VaFacility.find_by(id: id)

        if facility
          if facility.diffusion_histories.empty? && facility.practice_origin_facilities.empty?
            # facility has no associated practices, proceed with deletion
            facility.destroy
            deleted_facilities[name] = id
            puts "Deleted facility: #{name}"
            deletion_count += 1
          else
            # facility has associated practices, don't delete

            # get practice names linked via diffusion_histories
            diffusion_histories_practice_names = facility.diffusion_histories.includes(:practice).map do |history|
              history.practice.name if history.practice.present?
            end.compact

            # get practice names linked via practice_origin_facilities
            origin_facilities_practice_names = facility.practice_origin_facilities.includes(:practice).map do |origin_facility|
              origin_facility.practice.name if origin_facility.practice.present?
            end.compact

            non_deleted_facilities[name] = {
              id: id,
              diffusion_histories_count: diffusion_histories_practice_names.count,
              linked_innovations_via_diffusion_histories: diffusion_histories_practice_names,
              origin_facilities_count: origin_facilities_practice_names.count,
              linked_innovations_via_origin_facilities: origin_facilities_practice_names
            }
          end
        end
      end

      if deleted_facilities.any? || non_deleted_facilities.any?
        File.open(output_file, "w") do |file|
          file.write({
            deleted_facilities: deleted_facilities,
            non_deleted_facilities: non_deleted_facilities
          }.to_json)
        end

        puts "#{deletion_count} non-current facilities have been deleted."
        puts "Results saved to #{output_file}."
      else
        puts "No non-current facilities were deleted or skipped, no output file created."
      end
    else
      puts "
            No file found with non-current facility IDs for today's date.\n
            Run thecreate_or_update_va_facilities task to generate a file containing the IDs of
            facilities that are not present in the imported facilities data.\n
            If none are found no file will be generated.
          "
    end
  end

  task :facilities_import_check => :environment do
    file = File.read("#{Rails.root}/lib/assets/va_facilities.json")
    va_facilities = JSON.parse(file)
    current_date = Date.today.strftime("%Y-%m-%d")
    output_file = "#{Rails.root}/lib/assets/potential_facility_duplicates_#{current_date}.json"

    import_station_names = va_facilities.map { |vaf| vaf["Official Station Name"] }
    va_facilities_db = VaFacility.where(official_station_name: import_station_names).index_by(&:official_station_name)

    mismatches = []

    va_facilities.each do |vaf|
      potential_match = va_facilities_db[vaf["Official Station Name"]]

      if potential_match && potential_match.visn.number == vaf["VISN"].to_i && potential_match.station_number != vaf["Station Number"].to_s
        mismatch_data = {
          db_id: potential_match.id,
          db_station_number: potential_match.station_number,
          db_official_station_name: potential_match.official_station_name,
          new_official_station_name: vaf["Official Station Name"],
          new_station_number: vaf["Station Number"]
        }

        mismatches << mismatch_data

        puts "Potential duplicate found:"
        puts "DB Record -> ID: #{mismatch_data[:db_id]}, Station Number: #{mismatch_data[:db_station_number]}, Official Station Name: #{mismatch_data[:db_official_station_name]}"
        puts "New Record -> Official Station Name: #{mismatch_data[:new_official_station_name]}, Station Number: #{mismatch_data[:new_station_number]}"
      end
    end

    if mismatches.any?
      File.open(output_file, "w") do |file|
        file.write(mismatches.to_json)
      end

      puts "#{mismatches.count} potential facility duplicates found and saved to output file: #{output_file}."
    else
      puts "No potential facility duplicates found, no output file created."
    end
  end

  desc 'Fix bad data in the va_facilities table'
  task :fix_data_va_facilities => :environment do
    facilities = VaFacility.all
    facilities.each do |facility|
      if facility.fy17_parent_station_complexity_level === '2 -Medium Complexity'
        facility.fy17_parent_station_complexity_level = '2-Medium Complexity'
        facility.save
        count += 1
      end
      if facility.fy17_parent_station_complexity_level === '3 -Low Complexity'
        facility.fy17_parent_station_complexity_level = '3-Low Complexity'
        facility.save
        count += 1
      end
    end
    puts "VA complexity levels have been updated in the DB!"
    puts "Updated #{count} facilities"
  end

  def valid_json?(json)
    JSON.parse(json)
    return true

    rescue JSON::ParserError => e
      return false
  end
end