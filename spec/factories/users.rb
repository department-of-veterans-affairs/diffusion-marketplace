FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.username + "@va.gov" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { 'Password123' }
    password_confirmation { 'Password123' }
    skip_va_validation { true }
    confirmed_at { Time.now }
    accepted_terms { true }
  end

  trait :admin do
    after(:create) do |user|
      user.add_role :admin
    end
  end
end
