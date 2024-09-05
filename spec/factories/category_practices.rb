FactoryBot.define do
  factory :category_practice do
    association :category
    association :innovable, factory: :practice
  end
end
