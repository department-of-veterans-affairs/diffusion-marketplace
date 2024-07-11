FactoryBot.define do
  factory :category do
    name { Faker::Company.unique.name }
  end

  trait :with_sub_categories do
    after(:create) do |category|
      create_list(:category, 3, parent_category: category)
    end
  end

  trait :community do
    name { "Communities" }
  end
end
