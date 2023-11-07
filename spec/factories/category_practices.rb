FactoryBot.define do
  factory :category_practice do
    association :practice
    association :category
  end
end
