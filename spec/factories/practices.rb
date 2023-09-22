FactoryBot.define do
  factory :practice do
    association :user

    name { Faker::Company.unique.name }
    tagline { Faker::Lorem.sentence }

    trait :approved do
      approved { true }
    end

    trait :published do
      published { true }
    end

    trait :approved_and_published do
      approved { true }
      published { true }
    end

    trait :public_practice do
      published { true }
      enabled { true }
      approved { true }
      hidden { false }
      is_public { true }
    end

    trait :private_practice do
      published { true }
      enabled { true }
      approved { true }
      hidden { false }
      is_public { false }
    end
  end
end