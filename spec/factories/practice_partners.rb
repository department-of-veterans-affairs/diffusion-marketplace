FactoryBot.define do
  factory :practice_partner do
    name { Faker::Company.unique.name }
    short_name { Faker::Company.unique.name } # Generates a 3-letter initials
    description { Faker::Lorem.paragraph }
    position { Faker::Number.non_zero_digit }
    color { Faker::Color.hex_color }
    icon { Faker::Lorem.word }
    
    trait :not_major_partner do
      is_major { false }
    end

    is_major { true }

    trait :for_products do
      sequence :name, ["VHA Innovators Network", "VA Technology Transfer Program", "iNet Seed-Spark-Spread Innovation Investment Program"].cycle
    end
  end
end
