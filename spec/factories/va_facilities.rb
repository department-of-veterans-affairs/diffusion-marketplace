FactoryBot.define do
  factory :va_facility do
    association :visn
    
    sta3n { Faker::Number.unique.number(digits: 5) }
    station_number { Faker::Number.unique.number(digits: 5) }
    official_station_name { Faker::Company.unique.name }
    common_name { Faker::Company.unique.industry }
    fy17_parent_station_complexity_level { Faker::Lorem.unique.word }
    latitude { Faker::Address.unique.latitude }
    longitude { Faker::Address.unique.longitude }
    rurality { Faker::Alphanumeric.alpha(number: 1) }
    street_address { Faker::Address.unique.street_address }
    street_address_city { Faker::Address.unique.city }
    street_address_state { Faker::Address.unique.state_abbr }
    station_phone_number { Faker::PhoneNumber.unique.phone_number }
    street_address_zip_code { Faker::Address.unique.zip_code }
    slug { Faker::Internet.unique.slug }
    station_number_suffix_reservation_effective_date { Faker::Date.backward }
    mailing_address_city { Faker::Address.unique.city }
    classification { Faker::Lorem.unique.word }
    classification_status { Faker::Lorem.unique.word }
    mobile { Faker::Boolean.boolean.to_s }
    parent_station_number { Faker::Number.unique.number(digits: 3) }
    official_parent_station_name { Faker::Company.unique.name }
  end
end