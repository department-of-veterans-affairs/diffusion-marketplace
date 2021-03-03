namespace :vamcs do
  desc 'Create new VAMC records based on the data from the vamc.json file'

  task :create_vamcs_and_transfer_data => :environment do
    vamc_data = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    visns = Visn.all

    visns.each do |visn|
      vamc_data.each do |vamc|
        if visn.number === vamc["VISN"].to_i
          Vamc.create!(
            visn: visn,
            sta3n: vamc["STA3N"],
            station_number: vamc["StationNumber"],
            official_station_name: vamc["OfficialStationName"],
            common_name: vamc["CommonName"],
            classification: vamc["Classification"],
            classification_status: vamc["ClassificationStatus"],
            mobile: vamc["Mobile"],
            parent_station_number: vamc["ParentStationNumber"],
            official_parent_station_name: vamc["OfficialParentStationName"],
            fy17_parent_station_complexity_level: vamc["FY17ParentStationComplexityLevel"],
            operational_status: vamc["OperationalStatus"],
            ownership_type: vamc["OwnershipType"],
            delivery_mechanism: vamc["DeliveryMechanism"] || nil,
            staffing_type: vamc["StaffingType"],
            va_secretary_10n_approved_date: vamc["VASecretary10NApprovedDate"],
            planned_activation_date: vamc["PlannedActivationDate"],
            station_number_suffix_reservation_effective_date: vamc["StationNumberSuffixReservationEffectiveDate"],
            operational_date: vamc["OperationalDate"],
            date_of_first_workload: vamc["DateOfFirstWorkload"],
            points_of_service: vamc["PointsofService"],
            street_address: vamc["StreetAddress"],
            street_address_city: vamc["StreetAddressCity"],
            street_address_state: vamc["StreetAddressState"],
            street_address_zip_code: vamc["StreetAddressZipCode"],
            street_address_zip_code_extension: vamc["StreetAddressZipCodeExtension"],
            county_street_address: vamc["CountyStreetAddress"],
            mailing_address: vamc["MailingAddress"],
            mailing_address_city: vamc["MailingAddressCity"],
            mailing_address_state: vamc["MailingAddressState"],
            mailing_address_zip_code: vamc["MailingAddressZipCode"],
            mailing_address_zip_code_extension: vamc["MailingAddressZipCodeExtension"],
            county_mailing_address: vamc["CountyMailingAddress"],
            station_phone_number: vamc["StationPhoneNumber"],
            station_main_fax_number: vamc["StationMainFaxNumber"],
            after_hours_phone_number: vamc["AfterHoursPhoneNumber"],
            pharmacy_phone_number: vamc["PharmacyPhoneNumber"],
            enrollment_coordinator_phone_number: vamc["EnrollmentCoordinatorPhoneNumber"],
            patient_advocate_phone_number: vamc["PatientAdvocatePhoneNumber"],
            latitude: vamc["Latitude"].to_f,
            longitude: vamc["Longitude"].to_f,
            congressional_district: vamc["CongressionalDistrict"],
            market: vamc["MARKET"],
            sub_market: vamc["SUBMARKET"],
            sector: vamc["SECTOR"],
            fips_code: vamc["FIPSCode"],
            rurality: vamc["Rurality"],
            monday: vamc["Monday"],
            tuesday: vamc["Tuesday"],
            wednesday: vamc["Wednesday"],
            thursday: vamc["Thursday"],
            friday: vamc["Friday"],
            saturday: vamc["Saturday"],
            sunday: vamc["Sunday"],
            hours_note: vamc["HoursNote"]
          )
        end
      end
    end

    puts "All VAMCs have now been added to the DB!"

  end
end