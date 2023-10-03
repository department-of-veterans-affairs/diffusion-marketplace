FactoryBot.define do
  factory :diffusion_history_status do
    association :diffusion_history
    status { 'Complete' }

    trait :in_progress do
      status { 'In progress' }
    end

    trait :planning do
      status { 'Planning' }
    end

    trait :implementing do
      status { 'Implementing' }
    end

    trait :completed do
      status { 'Completed' }
    end

    trait :implemented do
      status { 'Implemented' }
    end

    trait :complete do
      status { 'Complete' }
    end

    trait :unsuccessful do
      status { 'Unsuccessful' }
      unsuccessful_reasons { [Faker::Number.between(from: 0, to: 5)] }
      unsuccessful_reasons_other { 'Additional context for the "Other" reason' }
    end
  end
end
