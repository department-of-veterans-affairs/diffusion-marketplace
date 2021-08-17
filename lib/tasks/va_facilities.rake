require 'uri'
require 'net/http'
require 'json'

namespace :va_facilities do
  desc 'Create new VA facility records based on the data from the vamc.json file'

  task :create_va_facilities_and_transfer_data => :environment do
    va_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    visns = Visn.all

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
        end
      end
    end

    puts "All VA facilities have now been added to the DB!"
  end

  task :update_va_facilities_via_lighthouse_api => :environment do
    API_KEY = "s4He5m5fEWbqJmoJzuomJ5eLBso92GUz"
    # Sandbox: https://sandbox-api.va.gov/services/va_facilities/v0  Key: s4He5m5fEWbqJmoJzuomJ5eLBso92GUz
    # Production: https://api.va.gov/services/va_facilities/v0      Key: TBD - need to request prod key

    # get all facilities....  fyi - doesn't contain all the facility meta data.... have to call individual facility json for all properties.
    uri = URI('https://sandbox-api.va.gov/services/va_facilities/v0/facilities/all?apikey=' + API_KEY)
    res = Net::HTTP.get_response(uri)
    debugger
    ctr = 0
    if valid_json?(res.body)
      @va_facs = JSON.parse(res.body)
      @va_facs['features'].each do |facs|
        vha_id = facs["properties"]["id"]
        if vha_id.include?("vha_")  #only care about VHA facilities...
              # puts facs["properties"]["id"]
              # puts facs["properties"]["name"]
              # get the individual facility meta data....
              uri_2 = URI('https://sandbox-api.va.gov/services/va_facilities/v0/facilities/' + facs["properties"]["id"] + '?apikey=' + API_KEY)
              res_2 = Net::HTTP.get_response(uri_2)
              if valid_json?(res_2.body)
                #puts res_2.body
                @va_fac = JSON.parse(res_2.body)
              end
              ctr += 1
              if ctr % 10 == 0
                puts ctr
              end
        end
      end
    end

    debugger

    # uri = URI('https://sandbox-api.va.gov/services/va_facilities/v0/facilities/all?apikey=' + API_KEY)
    # req = Net::HTTP::Get.new(uri)
    # req['ACCEPT'] = "application/geo+json"
    #
    # res = Net::HTTP.get_response(req)
    # debugger
    # response = Net::HTTP.start(uri.hostname) do |http|
    #   http.request(req)
    # end
    # debugger
  end

  def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end

end