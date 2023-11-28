FactoryBot.define do
  factory :page do
    association :page_group

    sequence(:title) { |n| "Page Title #{n}" }
    sequence(:description) { |n| "Page Description #{n}" }
    sequence(:slug) { |n| "page-slug-#{n}" }
    
    created_at { Time.now }
    updated_at { Time.now }
    published { Time.now }
    ever_published { false }
    is_visible { true }
    template_type { 0 }
    has_chrome_warning_banner { false }
    image_alt_text { "Sample Image Alt Text" }
    image_file_name { "sample_image.jpg" }
    image_content_type { "image/jpeg" }
    image_file_size { 1024 }
    image_updated_at { Time.now }
    is_public { false }

    # Optional: Add traits or additional configurations if needed.
  end
end