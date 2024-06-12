FactoryBot.define do
  factory :category do
    name { Faker::Company.unique.name }
    is_other { false }
  end

  trait :with_sub_categories do
    after(:create) do |category|
      create_list(:category, 3, parent_category: category)
    end
  end

  trait :as_parent do
    is_other { false }
  end

  trait :community do
    name { "Communities" }
  end
end
