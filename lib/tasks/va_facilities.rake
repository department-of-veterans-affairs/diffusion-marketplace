namespace :va_facilities do
  desc 'Create new VA facility records based on the data from the va_facilities.json file'

  task :create_or_update_va_facilities => :environment do
    ctr = 0
    file = File.read("#{Rails.root}/lib/assets/va_facilities.json")
    va_facilities = JSON.parse(file)
    visns = Visn.all
    visns.each do |visn|
      va_facilities.each do |vaf|
      facility = VaFacility.where(station_number: vaf["Station Number"]).first
      classification = vaf["Classification"].blank? ? "Unclassified" : vaf["Classification"]
          if visn.number === vaf["VISN"].to_i && VaFacility.where(station_number: vaf["Station Number"]).empty?
            puts 'Creating facility - ' + vaf["Official Station Name"]
              hidden = vaf["Classification"].blank?
              VaFacility.create!(
                  visn: visn,
                  sta3n: vaf["STA3N"].to_s,
                  station_number: vaf["Station Number"],
                  official_station_name: vaf["Official Station Name"],
                  common_name: vaf["Location Descriptive Name"],
                  classification: classification,
                  classification_status: vaf["ClassificationStatus"],
                  mobile: vaf["Mobile"],
                  parent_station_number: vaf["Official Parent Station Number"],
                  official_parent_station_name: vaf["Parent Station Name"],
                  fy17_parent_station_complexity_level: vaf["FY20 Parent Station Complexity Level"],
                  operational_status: vaf["Operational Status Active A Or Planned P Or Temporarily Deactivated T Or Permanently Deactivated D"],
                  ownership_type: vaf["Ownership Type"],
                  delivery_mechanism: vaf["Delivery Mechanism"],
                  staffing_type: vaf["StaffingType"],

                  # these 3 not in VetCenter json schema...
                  va_secretary_10n_approved_date: vaf["VA Secretary / 10N Approved Date"],
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
                  county_street_address: vaf["County (Street Address)"],
                  mailing_address: vaf["Mailing Address"],
                  mailing_address_city: vaf["Mailing Address-City"],
                  mailing_address_state: vaf["Mailing Address-State"],
                  mailing_address_zip_code: vaf["Mailing Address-Zip Code"].to_s,
                  mailing_address_zip_code_extension: vaf["Mailing Address-Zip Code Extension"].to_s,
                  county_mailing_address: vaf["County (Mailing Address)"],
                  station_phone_number: vaf["Station Phone Number"],
                  station_main_fax_number: vaf["Station Main Fax Number"],

                  # these 4 not in VetCenter json schema...
                  after_hours_phone_number: vaf["After Hours Phone Number"],
                  pharmacy_phone_number: vaf["Pharmacy Phone Number"],
                  enrollment_coordinator_phone_number: vaf["Enrollment Coordinator Phone Number"],
                  patient_advocate_phone_number: vaf["Patient Advocate Phone Number"],

                  latitude: vaf["Latitude"].to_f,
                  longitude: vaf["Longitude"].to_f,
                  congressional_district: vaf["Congressional District"],
                  market: vaf["MARKET"],
                  sub_market: vaf["SUBMARKET"],
                  sector: vaf["SECTOR"],
                  fips_code: vaf["FIPS Code"],
                  rurality: vaf["Rurality: U=Urban; R=Rural; H=Highly ruralI=Insular"],
                  monday: vaf["Monday"],
                  tuesday: vaf["Tuesday"],
                  wednesday: vaf["Wednesday"],
                  thursday: vaf["Thursday"],
                  friday: vaf["Friday"],
                  saturday: vaf["Saturday"],
                  sunday: vaf["Sunday"],
                  hours_note: vaf["Hours Note"],
                  hidden: hidden
              )
          else
            # update record.....
            if facility.present? && visn.number === vaf["VISN"].to_i
              facility.visn = visn
              facility.sta3n = vaf["STA3N"].to_s
              facility.station_number = vaf["Station Number"]
              facility.official_station_name = vaf["Official Station Name"]
              facility.common_name = vaf["Location Descriptive Name"]
              puts 'Common_name: ' + facility.common_name
              facility.classification = classification
              facility.classification_status = vaf["ClassificationStatus"]
              facility.mobile = vaf["Mobile"]
              facility.parent_station_number = vaf["Official Parent Station Number"]
              facility.official_parent_station_name = vaf["Parent Station Name"]
              facility.fy17_parent_station_complexity_level = vaf["FY20 Parent Station Complexity Level"]
              facility.operational_status = vaf["Operational Status Active A Or Planned P Or Temporarily Deactivated T Or Permanently Deactivated D"]
              facility.ownership_type = vaf["Ownership Type"]
              facility.delivery_mechanism = vaf["Delivery Mechanism"]
              facility.staffing_type = vaf["StaffingType"]
              facility.operational_date = vaf["Operational Date"]
              facility.date_of_first_workload = vaf["Date Of First Workload"]
              facility.points_of_service = vaf["Points of Service"].to_s
              facility.street_address = vaf["Street Address"]
              facility.street_address_city = vaf["Street Address-City"]
              facility.street_address_state = vaf["Street Address-State"]
              facility.street_address_zip_code = vaf["Street Address-Zip Code"].to_s
              facility.street_address_zip_code_extension = vaf["Street Address-Zip Code Extension"].to_s
              facility.county_street_address = vaf["County (Street Address)"]
              facility.mailing_address = vaf["Mailing Address"]
              facility.mailing_address_city = vaf["Mailing Address-City"]
              facility.mailing_address_state = vaf["Mailing Address-State"]
              facility.mailing_address_zip_code = vaf["Mailing Address-Zip Code"].to_s
              facility.mailing_address_zip_code_extension = vaf["Mailing Address-Zip Code Extension"].to_s
              facility.county_mailing_address = vaf["County (Mailing Address)"]
              facility.station_phone_number = vaf["Station Phone Number"]
              facility.station_main_fax_number = vaf["Station Main Fax Number"]

              #these 7 not in Vet Center schema...
              if (!vaf["Official Station Name"].include? "Vet Center")
                facility.after_hours_phone_number = vaf["After Hours Phone Number"]
                facility.pharmacy_phone_number = vaf["Pharmacy Phone Number"]
                facility.enrollment_coordinator_phone_number = vaf["Enrollment Coordinator Phone Number"]
                facility.patient_advocate_phone_number = vaf["Patient Advocate Phone Number"]
                facility.va_secretary_10n_approved_date = vaf["VA Secretary / 10N Approved Date"]
                facility.planned_activation_date = vaf["Planned Activation Date"]
                facility.station_number_suffix_reservation_effective_date = vaf["Station Number Suffix Reservation Effective Date"]
              end
              facility.latitude = vaf["Latitude"].to_f
              facility.longitude = vaf["Longitude"].to_f
              facility.congressional_district = vaf["Congressional District"]
              facility.market = vaf["MARKET"]
              facility.sub_market = vaf["SUBMARKET"]
              facility.sector = vaf["SECTOR"]
              facility.fips_code = vaf["FIPS Code"]
              facility.rurality = vaf["Rurality: U=Urban; R=Rural; H=Highly ruralI=Insular"]
              facility.monday = vaf["Monday"]
              facility.tuesday = vaf["Tuesday"]
              facility.wednesday = vaf["Wednesday"]
              facility.thursday = vaf["Thursday"]
              facility.friday = vaf["Friday"]
              facility.saturday = vaf["Saturday"]
              facility.sunday = vaf["Sunday"]
              facility.hours_note = vaf["Hours Note"]
              facility.save
              ctr += 1
              puts "Updated facility: #{vaf['Official Station Name']}, #{ctr.to_s}"
            end
          end
        end
      end
    puts "All VA facilities have been created or updated in the DB!"
  end


  desc 'Fix bad data in the va_facilities table'
  task :fix_data_va_facilities => :environment do
    facilities = VaFacility.all
    facilities.each do |facility|
      if facility.fy17_parent_station_complexity_level === '2 -Medium Complexity'
        facility.fy17_parent_station_complexity_level = '2-Medium Complexity'
        facility.save
      end
      if facility.fy17_parent_station_complexity_level === '3 -Low Complexity'
        facility.fy17_parent_station_complexity_level = '3-Low Complexity'
        facility.save
      end
    end
    puts "VA complexity levels have been updated in the DB!"
  end


  def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end