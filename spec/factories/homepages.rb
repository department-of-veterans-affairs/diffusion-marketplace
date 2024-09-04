FactoryBot.define do
  factory :homepage do
    section_title_one { 'Featured Innovations' }
    section_title_two { 'Trending Tags' }
    section_title_three { 'Innovation Communities' }

    trait :published do
      published { true }
    end

    factory :homepage_with_features do
      after(:create) do |homepage, context|
        create_list(:featured_innovation, 3, homepage: homepage)
        create_list(:featured_tag, 3, homepage: homepage)
        create_list(:featured_community, 3, homepage: homepage)
      end
    end
  end

  factory :homepage_feature do
    sequence(:title) { |n| "Featured #{n}" }
    description { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget mauris eget nibh consectetur efficitur in quis libero. Nulla ultrices.'}
    url { '/about' }
    cta_text { 'View feature' }

    factory :featured_innovation do
      sequence(:title) { |n| "Featured Innovation #{n}" }
      section_id { 1 }
      cta_text { 'View Innovation' }
    end

    factory :featured_tag do
      sequence(:title) { |n| "Featured Tag #{n}" }
      section_id { 2 }
      cta_text { 'Learn more' }
    end

    factory :featured_community do
      sequence(:title) { |n| "Featured Community #{n}" }
      section_id { 3 }
      cta_text { 'View Community' }
    end
  end
end