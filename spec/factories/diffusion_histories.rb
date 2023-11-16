FactoryBot.define do
  factory :diffusion_history do
    association :practice

    trait :with_va_facility do
      association :va_facility
    end

    trait :with_clinical_resource_hub do
      association :clinical_resource_hub
    end

    # there are places in the application that expect a diffusion_history to have an associated
    # diffusion_history_status, if you create a diffusion_history in rails console without one
    # of the :with_status traits it will cause a breakage, ie /diffusion-map

    trait :with_status_complete do
      after(:create) do |dh|
        create(:diffusion_history_status, :complete, diffusion_history: dh)
      end
    end

    trait :with_status_completed do
      after(:create) do |dh|
        create(:diffusion_history_status, :completed, diffusion_history: dh)
      end
    end

    trait :with_status_in_progress do
      after(:create) do |dh|
        create(:diffusion_history_status, :in_progress, diffusion_history: dh)
      end
    end

    trait :with_status_planning do
      after(:create) do |dh|
        create(:diffusion_history_status, :planning, diffusion_history: dh)
      end
    end

    trait :with_status_implementing do
      after(:create) do |dh|
        create(:diffusion_history_status, :implementing, diffusion_history: dh)
      end
    end

    trait :with_status_implemented do
      after(:create) do |dh|
        create(:diffusion_history_status, :implemented, diffusion_history: dh)
      end
    end

    trait :with_status_unsuccessful do
      after(:create) do |dh|
        create(:diffusion_history_status, :unsuccessful, diffusion_history: dh)
      end
    end
  end
end
