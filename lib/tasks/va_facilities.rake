namespace :va_facilities do
  desc 'Create new VA facility records based on the data from the vamc.json file'

  task :create_va_facilities_and_transfer_data => :environment do
    va_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/va_facilities.json"))
    visns = Visn.all
    visns.each do |visn|
      puts visn.id
      va_facilities.each do |vaf|
        if visn.number === vaf["VISN"].to_i && VaFacility.where(station_number: vaf["Station_Number"]).empty?
          VaFacility.create!(
            visn: visn,
            sta3n: vaf["STA3N"],
            station_number: vaf["Station_Number"],
            official_station_name: vaf["Official_Station_Name"],
            common_name: vaf["Station_Number"],
            classification: vaf["CoCClassification"],
            classification_status: vaf["CoCClassificationAttribute"],
            mobile: vaf["Mobile"],
            parent_station_number: vaf["Parent_Station_Number"],
            official_parent_station_name: vaf["Parent_Station_Name"],
            fy17_parent_station_complexity_level: vaf["Parent_Station_Complexity_Level_2017"],
            operational_status: vaf["Operational_Status_Active_A_Or_Planned_P_Or_Temporarily_Deactivated_T_Or_Permanently_Deactivated_D"],
            ownership_type: vaf["Ownership_Type"],
            delivery_mechanism: vaf["Delivery_Mechanism"],
            staffing_type: vaf["Staffing_Type"],
            operational_date: vaf["Operational_Date"],
            date_of_first_workload: vaf["DateOfFirstWorkload"],
            points_of_service: vaf["Points_Of_Service"],
            street_address: vaf["Street_Address"],
            street_address_city: vaf["Street_Address_City"],
            street_address_state: vaf["Street_Address_State"],
            street_address_zip_code: vaf["Street_Address_Zip_Code"],
            street_address_zip_code_extension: vaf["Street_Address_Zip_Code_Extension"],
            county_street_address: vaf["County_Street_Address"],
            mailing_address: vaf["Mailing_Address"],
            mailing_address_city: vaf["Mailing_Address_City"],
            mailing_address_state: vaf["Mailing_Address_State"],
            mailing_address_zip_code: vaf["Mailing_Address_Zip_Code"],
            mailing_address_zip_code_extension: vaf["Mailing_Address_Zip_Code_Extension"],
            county_mailing_address: vaf["County_Mailing_Address"],
            station_phone_number: vaf["Station_Phone_Number"],
            station_main_fax_number: vaf["Station_Main_Fax_Number"],
            latitude: vaf["Latitude"].to_f,
            longitude: vaf["Longitude"].to_f,
            congressional_district: vaf["Congressional_District"],
            market: vaf["MARKET"],
            sub_market: vaf["SUBMARKET"],
            sector: vaf["SECTOR"],
            fips_code: vaf["FIPS_Code"],
            rurality: vaf["Rurality_U_Urban_R_Rural_H_Highly_Rural"],
            monday: vaf["Monday"],
            tuesday: vaf["Tuesday"],
            wednesday: vaf["Wednesday"],
            thursday: vaf["Thursday"],
            friday: vaf["Friday"],
            saturday: vaf["Saturday"],
            sunday: vaf["Sunday"],
            hours_note: vaf["HoursNote"]
          )
        end
      end
    end
    puts "All VA facilities have been created or updated in the DB!"
  end


  task :update_va_facilities => :environment do
    ctr = 0
    file = File.read("#{Rails.root}/lib/assets/va_facilities.json")
    va_facilities = JSON.parse(file)
    visns = Visn.all
    visns.each do |visn|
      puts 'VISN: ' +  visn.number.to_s
      va_facilities.each do |vaf|
          if visn.number === vaf["VISN"].to_i && VaFacility.where(station_number: vaf["Station_Number"]).empty?
            puts 'Creating facility - ' + vaf["Official_Station_Name"]
            if (vaf["Official_Station_Name"].include? "Vet Center")
              create_vet_center_facility(visn, vaf, true)
            else
              hidden = vaf["CoCClassification"].blank? ? true : false
              classification = vaf["CoCClassification"].blank? ? "Unclassified" : vaf["CoCClassification"]
              VaFacility.create!(
                  visn: visn,
                  sta3n: vaf["STA3N"],
                  station_number: vaf["Station_Number"],
                  official_station_name: vaf["Official_Station_Name"],
                  common_name: vaf["LocationDescriptiveName"],
                  classification: classification,
                  classification_status: vaf["CoCClassificationAttribute"],
                  mobile: vaf["Mobile"],
                  parent_station_number: vaf["Parent_Station_Number"],
                  official_parent_station_name: vaf["Parent_Station_Name"],
                  fy17_parent_station_complexity_level: vaf["Parent_Station_Complexity_Level_2017"],
                  operational_status: vaf["Operational_Status_Active_A_Or_Planned_P_Or_Temporarily_Deactivated_T_Or_Permanently_Deactivated_D"],
                  ownership_type: vaf["Ownership_Type"],
                  delivery_mechanism: vaf["Delivery_Mechanism"],
                  staffing_type: vaf["Staffing_Type"],

                  # these 3 not in VetCenter json schema...
                  va_secretary_10n_approved_date: vaf["VA_Secretary_10N_Approved_Date"],
                  planned_activation_date: vaf["Planned_Activation_Date"],
                  station_number_suffix_reservation_effective_date: vaf["StationNumberSuffixReservationEffectiveDate"],


                  operational_date: vaf["Operational_Date"],
                  date_of_first_workload: vaf["DateOfFirstWorkload"],
                  points_of_service: vaf["Points_Of_Service"],
                  street_address: vaf["Street_Address"],
                  street_address_city: vaf["Street_Address_City"],
                  street_address_state: vaf["Street_Address_State"],
                  street_address_zip_code: vaf["Street_Address_Zip_Code"],
                  street_address_zip_code_extension: vaf["Street_Address_Zip_Code_Extension"],
                  county_street_address: vaf["County_Street_Address"],
                  mailing_address: vaf["Mailing_Address"],
                  mailing_address_city: vaf["Mailing_Address_City"],
                  mailing_address_state: vaf["Mailing_Address_State"],
                  mailing_address_zip_code: vaf["Mailing_Address_Zip_Code"],
                  mailing_address_zip_code_extension: vaf["Mailing_Address_Zip_Code_Extension"],
                  county_mailing_address: vaf["County_Mailing_Address"],
                  station_phone_number: vaf["Station_Phone_Number"],
                  station_main_fax_number: vaf["Station_Main_Fax_Number"],

                  # these 4 not in VetCenter json schema...
                  after_hours_phone_number: vaf["After_Hours_Phone_Number"],
                  pharmacy_phone_number: vaf["Pharmacy_Phone_Number"],
                  enrollment_coordinator_phone_number: vaf["Enrollment_Coordinator_Phone_Number"],
                  patient_advocate_phone_number: vaf["Patient_Advocate_Phone_Number"],

                  latitude: vaf["Latitude"].to_f,
                  longitude: vaf["Longitude"].to_f,
                  congressional_district: vaf["Congressional_District"],
                  market: vaf["MARKET"],
                  sub_market: vaf["SUBMARKET"],
                  sector: vaf["SECTOR"],
                  fips_code: vaf["FIPS_Code"],
                  rurality: vaf["Rurality_U_Urban_R_Rural_H_Highly_Rural"],
                  monday: vaf["Monday"],
                  tuesday: vaf["Tuesday"],
                  wednesday: vaf["Wednesday"],
                  thursday: vaf["Thursday"],
                  friday: vaf["Friday"],
                  saturday: vaf["Saturday"],
                  sunday: vaf["Sunday"],
                  hours_note: vaf["HoursNote"],
                  hidden: hidden
              )
            end
          else
            # update record.....
            facility = VaFacility.where(station_number: vaf["Station_Number"]).first
            if facility.present? && visn.number === vaf["VISN"].to_i
              puts 'facility not blank and visn # good'
              facility.visn = visn
              facility.sta3n = vaf["STA3N"]
              facility.station_number = vaf["Station_Number"]
              facility.official_station_name = vaf["Official_Station_Name"]
              facility.common_name = vaf["LocationDescriptiveName"]
              puts 'Common_name: ' + facility.common_name
              facility.classification = vaf["CoCClassification"]
              facility.classification_status = vaf["CoCClassificationAttribute"]
              facility.mobile = vaf["Mobile"]
              facility.parent_station_number = vaf["Parent_Station_Number"]
              facility.official_parent_station_name = vaf["Parent_Station_Name"]
              facility.fy17_parent_station_complexity_level = vaf["Parent_Station_Complexity_Level_2017"]
              facility.operational_status = vaf["Operational_Status_Active_A_Or_Planned_P_Or_Temporarily_Deactivated_T_Or_Permanently_Deactivated_D"]
              facility.ownership_type = vaf["Ownership_Type"]
              facility.delivery_mechanism = vaf["Delivery_Mechanism"]
              facility.staffing_type = vaf["Staffing_Type"]
              facility.operational_date = vaf["Operational_Date"]
              facility.date_of_first_workload = vaf["DateOfFirstWorkload"]
              facility.points_of_service = vaf["Points_Of_Service"]
              facility.street_address = vaf["Street_Address"]
              facility.street_address_city = vaf["Street_Address_City"]
              facility.street_address_state = vaf["Street_Address_State"]
              facility.street_address_zip_code = vaf["Street_Address_Zip_Code"]
              facility.street_address_zip_code_extension = vaf["Street_Address_Zip_Code_Extension"]
              facility.county_street_address = vaf["County_Street_Address"]
              facility.mailing_address = vaf["Mailing_Address"]
              facility.mailing_address_city = vaf["Mailing_Address_City"]
              facility.mailing_address_state = vaf["Mailing_Address_State"]
              facility.mailing_address_zip_code = vaf["Mailing_Address_Zip_Code"]
              facility.mailing_address_zip_code_extension = vaf["Mailing_Address_Zip_Code_Extension"]
              facility.county_mailing_address = vaf["County_Mailing_Address"]
              facility.station_phone_number = vaf["Station_Phone_Number"]
              facility.station_main_fax_number = vaf["Station_Main_Fax_Number"]

              #these 7 not in Vet Center schema...
              if (!vaf["Official_Station_Name"].include? "Vet Center")
                facility.after_hours_phone_number = vaf["After_Hours_Phone_Number"]
                facility.pharmacy_phone_number = vaf["Pharmacy_Phone_Number"]
                facility.enrollment_coordinator_phone_number = vaf["Enrollment_Coordinator_Phone_Number"]
                facility.patient_advocate_phone_number = vaf["Patient_Advocate_Phone_Number"]
                facility.va_secretary_10n_approved_date = vaf["VA_Secretary_10N_Approved_Date"]
                facility.planned_activation_date = vaf["Planned_Activation_Date"]
                facility.station_number_suffix_reservation_effective_date = vaf["StationNumberSuffixReservationEffectiveDate"]
              end


              facility.latitude = vaf["Latitude"].to_f
              facility.longitude = vaf["Longitude"].to_f
              facility.congressional_district = vaf["Congressional_District"]
              facility.market = vaf["MARKET"]
              facility.sub_market = vaf["SUBMARKET"]
              facility.sector = vaf["SECTOR"]
              facility.fips_code = vaf["FIPS_Code"]
              facility.rurality = vaf["Rurality_U_Urban_R_Rural_H_Highly_Rural"]
              facility.monday = vaf["Monday"]
              facility.tuesday = vaf["Tuesday"]
              facility.wednesday = vaf["Wednesday"]
              facility.thursday = vaf["Thursday"]
              facility.friday = vaf["Friday"]
              facility.saturday = vaf["Saturday"]
              facility.sunday = vaf["Sunday"]
              facility.hours_note = vaf["HoursNote"]
              facility.save
              ctr += 1
              puts "Updated facility: #{vaf['Official_Station_Name']}, #{ctr.to_s}"
            end
          end
        end
      end
    puts "All VA facilities have been created or updated in the DB!"
  end

  def create_vet_center_facility(visn, vaf, hidden)
    VaFacility.create!(
        visn: visn,
        sta3n: vaf["STA3N"],
        station_number: vaf["Station_Number"],
        official_station_name: vaf["Official_Station_Name"],
        common_name: vaf["LocationDescriptiveName"],
        classification: vaf["CoCClassification"],
        classification_status: vaf["CoCClassificationAttribute"],
        mobile: vaf["Mobile"],
        parent_station_number: vaf["Parent_Station_Number"],
        official_parent_station_name: vaf["Parent_Station_Name"],
        fy17_parent_station_complexity_level: vaf["Parent_Station_Complexity_Level_2017"],
        operational_status: vaf["Operational_Status_Active_A_Or_Planned_P_Or_Temporarily_Deactivated_T_Or_Permanently_Deactivated_D"],
        ownership_type: vaf["Ownership_Type"],
        delivery_mechanism: vaf["Delivery_Mechanism"],
        staffing_type: vaf["Staffing_Type"],
        operational_date: vaf["Operational_Date"],
        date_of_first_workload: vaf["DateOfFirstWorkload"],
        points_of_service: vaf["Points_Of_Service"],
        street_address: vaf["Street_Address"],
        street_address_city: vaf["Street_Address_City"],
        street_address_state: vaf["Street_Address_State"],
        street_address_zip_code: vaf["Street_Address_Zip_Code"],
        street_address_zip_code_extension: vaf["Street_Address_Zip_Code_Extension"],
        county_street_address: vaf["County_Street_Address"],
        mailing_address: vaf["Mailing_Address"],
        mailing_address_city: vaf["Mailing_Address_City"],
        mailing_address_state: vaf["Mailing_Address_State"],
        mailing_address_zip_code: vaf["Mailing_Address_Zip_Code"],
        mailing_address_zip_code_extension: vaf["Mailing_Address_Zip_Code_Extension"],
        county_mailing_address: vaf["County_Mailing_Address"],
        station_phone_number: vaf["Station_Phone_Number"],
        station_main_fax_number: vaf["Station_Main_Fax_Number"],
        latitude: vaf["Latitude"].to_f,
        longitude: vaf["Longitude"].to_f,
        congressional_district: vaf["Congressional_District"],
        market: vaf["MARKET"],
        sub_market: vaf["SUBMARKET"],
        sector: vaf["SECTOR"],
        fips_code: vaf["FIPS_Code"],
        rurality: vaf["Rurality_U_Urban_R_Rural_H_Highly_Rural"],
        monday: vaf["Monday"],
        tuesday: vaf["Tuesday"],
        wednesday: vaf["Wednesday"],
        thursday: vaf["Thursday"],
        friday: vaf["Friday"],
        saturday: vaf["Saturday"],
        sunday: vaf["Sunday"],
        hours_note: vaf["HoursNote"],
        hidden: hidden
    )
  end



  def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end