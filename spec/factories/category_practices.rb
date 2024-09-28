FactoryBot.define do
  factory :category_practice do
    association :category

    factory :category_practice_for_product do
      association :innovable, factory: :product
    end
  end
end
