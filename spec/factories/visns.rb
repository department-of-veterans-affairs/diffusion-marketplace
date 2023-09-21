FactoryBot.define do
  factory :visn do
    name { Faker::Company.unique.name }
    number { Faker::Number.unique.between(from: 1, to: 99) }
  end
end