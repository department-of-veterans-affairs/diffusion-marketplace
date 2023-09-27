FactoryBot.define do
  factory :visn do
    name { Faker::Company.unique.name }
    sequence(:number) { |n| n }
  end
end
