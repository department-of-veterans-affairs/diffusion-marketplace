FactoryBot.define do
  factory :page_component do
    association :page
    position { [1, 2, 3, 4, 5].sample }
    component_type { 'PageDownloadableFileComponent' }
    component_id { SecureRandom.uuid }

    trait :with_downloadable_file_component do
      after(:build) do |page_component|
        downloadable_file_component = build(:page_downloadable_file_component)
        page_component.component = downloadable_file_component
      end
    end
  end
end
