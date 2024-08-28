FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    tagline { "This is a sample tagline for a product." }
    item_number { "ITEM12345" }
    vendor { "Sample Vendor" }
    duns { "123456789" }
    shipping_timeline_estimate { "2-3 weeks" }
    origin_story { "This product has an interesting origin story." }
    description { "This is a sample product description." }

    association :user

    trait :with_image do
      main_display_image { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/jumbotron-img.jpg'), 'image/jpg') }
    end
  end
end