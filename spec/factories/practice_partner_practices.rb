FactoryBot.define do
  factory :practice_partner_practice do
    association :practice_partner
    association :innovable
  end
end
