FactoryBot.define do
  factory :category_practice do
    association :category

    trait :for_product do
      association :innovable, factory: :product
    end

    trait :for_practice do
      association :innovable, factory: :practice
    end
  end
end
