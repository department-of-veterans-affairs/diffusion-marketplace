FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Sample Product #{n}" }
    tagline { "This is a sample tagline for a product." }
    item_number { "ITEM12345" }
    vendor { "Sample Vendor" }
    vendor_link { "https://va.gov"}
    duns { "123456789" }
    shipping_timeline_estimate { "2-3 weeks" }
    price { "$1000 and $100 shipping" }
    origin_story { "This product has an interesting origin story." }
    description { "This is a sample product description." }

    association :user

    trait :with_image do
      main_display_image { File.new(Rails.root.join('spec', 'assets', 'acceptable_img.jpg')) }
      main_display_image_caption { "sample image caption" }
      main_display_image_alt_text { "sample image alt text" }
    end

    trait :with_multimedia do
      after(:create) do |product|
        # Video
        PracticeMultimedium.create(
          link_url: "https://www.youtube.com/watch?v=-oazAtTm-lk",
          name: "Dr. Jeffrey Heckman speaks about the collaborative origins of FLOW3 and how it
          uses three custom-designed features to address issues with artificial limb authorizations.)",
          resource_type: "video",
          innovable: product
        )
        # Image
        PracticeMultimedium.create(
          name: "Dr. Jeffrey Heckman speaks about the collaborative origins of FLOW3 and how it
          uses three custom-designed features to address issues with artificial limb authorizations.)",
          resource_type: "image",
          innovable: product,
          attachment_file_name: "acceptable_img.jpg",
          image_alt_text: "a prescription bottle and pills",
          attachment: File.new(Rails.root.join('spec', 'assets', 'acceptable_img.jpg'))
        )
        # File
        PracticeMultimedium.create(
          name: "Implementation guide",
          description: "Tips on about implementing this practice at your facility",
          resource_type: "file",
          innovable: product,
          attachment_file_name: "dummy.pdf",
          attachment: File.new(Rails.root.join('spec', 'assets', 'dummy.pdf'))
        )
        # Link
        PracticeMultimedium.create(
          link_url: "https://va.gov",
          name: "VA Strategic Initiatives",
          description: "Learn more about the VHA Priorities",
          resource_type: "link",
          innovable: product
        )
      end
    end

    trait :with_va_employees do
      after(:create) do |product|
        create_list(:va_employee, 3).each do |va_e|
          VaEmployeePractice.create(
            innovable: product,
            va_employee: va_e
          )
        end
      end
    end

    trait :with_partners do
      after(:create) do |product|
        create_list(:practice_partner, 2, :for_products) do |partner|
          create(:practice_partner_practice, innovable: product, practice_partner: partner)
        end
      end
    end

    trait :with_tags do
        sequence(:name) { |n| "Sample Product with Tags #{n}" }
        after(:create) do |product|
        create_list(:category, 11).each do |category|
          create(:category_practice, :for_product, innovable: product, category: category)
        end
      end
    end
  end
end
