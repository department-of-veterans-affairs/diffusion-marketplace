FactoryBot.define do
  factory :clinical_resource_hub do
    association :visn
    official_station_name { "VISN #{Faker::Number.between(from: 1, to: 99)} Clinical Resource Hub (Remote)" }
  end
end
