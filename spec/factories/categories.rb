FactoryBot.define do
  factory :category do
    name { Faker::Company.unique.name }
    is_other { false }
  end
end
