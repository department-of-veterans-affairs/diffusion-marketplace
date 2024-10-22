namespace :va_facilities do
  desc 'Create new VA facility records based on the data from the va_facilities.json file'

  task :create_or_update_va_facilities => :environment do
    current_facility_ids = []
    ctr = 0
    file = File.read("#{Rails.root}/lib/assets/va_facilities.json")
    va_facilities = JSON.parse(file)
    visns = Visn.all
    visns.each do |visn|
      va_facilities.each do |vaf|
      facility = VaFacility.find_by(station_number: vaf["Station Number"])
      classification = vaf["Classification"].blank? ? "Unclassified" : vaf["Classification"]
          if visn.number === vaf["VISN"].to_i && VaFacility.where(station_number: vaf["Station Number"]).empty?
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
          else
            # update record.....
            if facility.present? && visn.number === vaf["VISN"].to_i
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
          end
          current_facility_ids << facility.id if facility&.persisted?

        end
      end

      non_current_facilities = VaFacility.where.not(id: current_facility_ids).pluck(:official_station_name, :id).to_h
      current_date = Date.today.strftime("%Y-%m-%d")
      filename = "#{Rails.root}/lib/assets/non_current_facility_ids_#{current_date}.json"

      File.open(filename, "w") do |file|
        file.write(non_current_facilities.to_json)
      end
    puts "All VA facilities have been created or updated in the DB!"
    puts "Non-current facility names and IDs saved to #{filename}."
  end

  task :delete_non_current_va_facilities => :environment do
    current_date = Date.today.strftime("%Y-%m-%d")
    file_path = "#{Rails.root}/lib/assets/non_current_facility_ids_#{current_date}.json"

    if File.exist?(file_path)
      non_current_facilities = JSON.parse(File.read(file_path))
      deletion_count = 0

      non_current_facilities.each_value do |id|
        facility = VaFacility.find_by(id: id)

        if facility && facility.diffusion_histories.empty? && facility.practice_origin_facilities.empty?
          name = facility.official_station_name
          facility.delete
          puts "Deleted facility: #{name}"
          deletion_count += 1
        end
      end

      puts "#{deletion_count} non-current facilities have been deleted."
    else
      puts "No file found with non-current facility IDs for today: #{file_path}"
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