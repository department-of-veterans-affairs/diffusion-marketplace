FactoryBot.define do
  factory :page do
    association :page_group

    sequence(:title) { |n| "Page Title #{n}" }
    sequence(:description) { |n| "Page Description #{n}" }
    sequence(:slug) { |n| "page-slug-#{n}" }
    
    created_at { Date.today }
    updated_at { Date.today }
    published { Date.today }
    ever_published { true }
    is_visible { true }
    template_type { 0 }
    is_public { false }
  end
end
