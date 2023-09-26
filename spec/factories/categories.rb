FactoryBot.define do
  factory :category do
    name { Faker::Company.unique.name }
  end
end