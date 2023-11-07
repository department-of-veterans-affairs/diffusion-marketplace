FactoryBot.define do
  factory :practice_email do
    practice
    address { 'email@example.com' }
  end
end