namespace :va_facilities do
  desc 'Create new VA facility records based on the data from the vamc.json file'

  task :create_va_facilities_and_transfer_data => :environment do
    debugger
    file = File.read("#{Rails.root}/lib/assets/va_facilities.json")
    if valid_json?(file)
      va_facilities = JSON.parse(file)
    end
    #va_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/va_facilities.json"))
    debugger
    visns = Visn.all
    debugger
    visns.each do |visn|
      va_facilities.each do |vaf|
        if visn.number === vaf["VISN"].to_i && VaFacility.where(station_number: vaf["StationNumber"]).empty?
          VaFacility.create!(
            visn: visn,
            sta3n: vaf["STA3N"],
            station_number: vaf["StationNumber"],
            official_station_name: vaf["OfficialStationName"],
            common_name: vaf["CommonName"],
            classification: vaf["Classification"],
            classification_status: vaf["ClassificationStatus"],
            mobile: vaf["Mobile"],
            parent_station_number: vaf["ParentStationNumber"],
            official_parent_station_name: vaf["OfficialParentStationName"],
            fy17_parent_station_complexity_level: vaf["FY17ParentStationComplexityLevel"],
            operational_status: vaf["OperationalStatus"],
            ownership_type: vaf["OwnershipType"],
            delivery_mechanism: vaf["DeliveryMechanism"],
            staffing_type: vaf["StaffingType"],
            va_secretary_10n_approved_date: vaf["VASecretary10NApprovedDate"],
            planned_activation_date: vaf["PlannedActivationDate"],
            station_number_suffix_reservation_effective_date: vaf["StationNumberSuffixReservationEffectiveDate"],
            operational_date: vaf["OperationalDate"],
            date_of_first_workload: vaf["DateOfFirstWorkload"],
            points_of_service: vaf["PointsofService"],
            street_address: vaf["StreetAddress"],
            street_address_city: vaf["StreetAddressCity"],
            street_address_state: vaf["StreetAddressState"],
            street_address_zip_code: vaf["StreetAddressZipCode"],
            street_address_zip_code_extension: vaf["StreetAddressZipCodeExtension"],
            county_street_address: vaf["CountyStreetAddress"],
            mailing_address: vaf["MailingAddress"],
            mailing_address_city: vaf["MailingAddressCity"],
            mailing_address_state: vaf["MailingAddressState"],
            mailing_address_zip_code: vaf["MailingAddressZipCode"],
            mailing_address_zip_code_extension: vaf["MailingAddressZipCodeExtension"],
            county_mailing_address: vaf["CountyMailingAddress"],
            station_phone_number: vaf["StationPhoneNumber"],
            station_main_fax_number: vaf["StationMainFaxNumber"],
            after_hours_phone_number: vaf["AfterHoursPhoneNumber"],
            pharmacy_phone_number: vaf["PharmacyPhoneNumber"],
            enrollment_coordinator_phone_number: vaf["EnrollmentCoordinatorPhoneNumber"],
            patient_advocate_phone_number: vaf["PatientAdvocatePhoneNumber"],
            latitude: vaf["Latitude"].to_f,
            longitude: vaf["Longitude"].to_f,
            congressional_district: vaf["CongressionalDistrict"],
            market: vaf["MARKET"],
            sub_market: vaf["SUBMARKET"],
            sector: vaf["SECTOR"],
            fips_code: vaf["FIPSCode"],
            rurality: vaf["Rurality"],
            monday: vaf["Monday"],
            tuesday: vaf["Tuesday"],
            wednesday: vaf["Wednesday"],
            thursday: vaf["Thursday"],
            friday: vaf["Friday"],
            saturday: vaf["Saturday"],
            sunday: vaf["Sunday"],
            hours_note: vaf["HoursNote"]
          )
        else
          debugger
          # update record.....
          facility = VaFacility.where(station_number: vaf["StationNumber"]).first
          facility.visn = visn
          facility.sta3n = vaf["STA3N"]
          facility.station_number = vaf["StationNumber"]
          facility.official_station_name = vaf["OfficialStationName"]
          facility.common_name = vaf["CommonName"]
          facility.classification = vaf["Classification"]
          facility.classification_status = vaf["ClassificationStatus"]
          facility.mobile = vaf["Mobile"]
          facility.parent_station_number = vaf["ParentStationNumber"]
          facility.official_parent_station_name = vaf["OfficialParentStationName"]
          facility.fy17_parent_station_complexity_level = vaf["FY17ParentStationComplexityLevel"]
          facility.operational_status = vaf["OperationalStatus"]
          facility.ownership_type = vaf["OwnershipType"]
          facility.delivery_mechanism = vaf["DeliveryMechanism"]
          facility.staffing_type = vaf["StaffingType"]
          facility.va_secretary_10n_approved_date = vaf["VASecretary10NApprovedDate"]
          facility.planned_activation_date = vaf["PlannedActivationDate"]
          facility.station_number_suffix_reservation_effective_date = vaf["StationNumberSuffixReservationEffectiveDate"]
          facility.operational_date = vaf["OperationalDate"]
          facility.date_of_first_workload = vaf["DateOfFirstWorkload"]
          facility.points_of_service = vaf["PointsofService"]
          facility.street_address = vaf["StreetAddress"]
          facility.street_address_city = vaf["StreetAddressCity"]
          facility.street_address_state = vaf["StreetAddressState"]
          facility.street_address_zip_code = vaf["StreetAddressZipCode"]
          facility.street_address_zip_code_extension = vaf["StreetAddressZipCodeExtension"]
          facility.county_street_address = vaf["CountyStreetAddress"]
          facility.mailing_address = vaf["MailingAddress"]
          facility.mailing_address_city = vaf["MailingAddressCity"]
          facility.mailing_address_state = vaf["MailingAddressState"]
          facility.mailing_address_zip_code = vaf["MailingAddressZipCode"]
          facility.mailing_address_zip_code_extension = vaf["MailingAddressZipCodeExtension"]
          facility.county_mailing_address = vaf["CountyMailingAddress"]
          facility.station_phone_number = vaf["StationPhoneNumber"]
          facility.station_main_fax_number = vaf["StationMainFaxNumber"]
          facility.after_hours_phone_number = vaf["AfterHoursPhoneNumber"]
          facility.pharmacy_phone_number = vaf["PharmacyPhoneNumber"]
          facility.enrollment_coordinator_phone_number = vaf["EnrollmentCoordinatorPhoneNumber"]
          facility.patient_advocate_phone_number = vaf["PatientAdvocatePhoneNumber"]
          facility.latitude = vaf["Latitude"].to_f
          facility.longitude = vaf["Longitude"].to_f
          facility.congressional_district = vaf["CongressionalDistrict"]
          facility.market = vaf["MARKET"]
          facility.sub_market = vaf["SUBMARKET"]
          facility.sector = vaf["SECTOR"]
          facility.fips_code = vaf["FIPSCode"]
          facility.rurality = vaf["Rurality"]
          facility.monday = vaf["Monday"]
          facility.tuesday = vaf["Tuesday"]
          facility.wednesday = vaf["Wednesday"]
          facility.thursday = vaf["Thursday"]
          facility.friday = vaf["Friday"]
          facility.saturday = vaf["Saturday"]
          facility.sunday = vaf["Sunday"]
          facility.hours_note = vaf["HoursNote"]
          facility.save
        end
      end
    end

    puts "All VA facilities have now been added to the DB!"
  end
  def valid_json?(json)
    debugger
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end