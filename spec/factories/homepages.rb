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

    factory :september_homepage do
      internal_title { 'September 2024' }
      after(:create) do |homepage, context|
        create_list(:september_innovation, 3, homepage: homepage)
        create_list(:september_tag, 3, homepage: homepage)
        create_list(:september_community, 2, homepage: homepage)
      end
    end
  end

  factory :homepage_feature do
    sequence(:title) { |n| "Featured #{n}" }
    description { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget mauris eget nibh consectetur efficitur in quis libero. Nulla ultrices.'}
    featured_image_file_name { 'neutral-placeholder.png' }
    sequence(:image_alt_text) { |n| "#{n} placeholder gray square" }
    featured_image { File.new(Rails.root.join('spec', 'assets', 'neutral-placeholder.png')) }
    url { '/about' }
    cta_text { 'View feature' }

    factory :featured_innovation do
      sequence(:title) { |n| "Featured Innovation #{n}" }
      section_id { 1 }
      cta_text { 'View Innovation' }

      factory :september_innovation do
        sequence :title, [
          "Veterans Socials: Veteran Outreach Into the Community to Expand Social Support (VOICES)",
          "The Equine-imity Project",
          "BraveMind"
        ].cycle
        sequence :description, [
          "Building social support systems with Veterans in the community is an important part of ensuring Veterans’ overall health. Veterans Socials enhance communication and foster bonds among Veterans and others in the community.",
          "The Equine-imity Project takes veterans out of the traditional clinical setting and into an alternative healing experience using horses. Our program offers an opportunity for veterans to learn about, and practice, fundamental life skills in a tangible way. ",
          "VHA Innovation Ecosystem (VHA IE) collaborated with SoldierStrong to provide VA medical facilities with a virtual reality (VR) program that helps Veterans experiencing post-traumatic stress (PTS) and post-traumatic stress disorder (PTSD) recover from these challenges."
        ].cycle
        image_file_names = [
          "innovation-voices.jpg",
          "innovation-equine.jpg",
          "innovation-bravemind.jpg"
        ]
        sequence :featured_image_file_name, image_file_names.cycle
        sequence :image_alt_text, [
          "Two veterans socializing",
          "A person petting a horse",
          "A patient wearing a VR headset"
        ].cycle
        sequence :featured_image do |n|
          File.new(Rails.root.join('spec', 'assets', 'homepage', image_file_names[n-1] ))
        end
      end
    end

    factory :featured_tag do
      sequence(:title) { |n| "Featured Tag #{n}" }
      section_id { 2 }
      cta_text { 'Learn more' }

      factory :september_tag do
        sequence :title, [
          "Suicide Prevention",
          "Home Health",
          "Specialty Care"
        ].cycle
        sequence :description, [
          "Discover our range of innovations focused on suicide prevention, ensuring Veterans receive the essential mental health care they deserve.",
          "Explore cutting-edge home health innovations, providing Veterans with personalized and accessible care in the comfort of their own homes.",
          "Access the latest innovations in specialty care, dedicated to providing advanced medical treatments and  personalized care tailored to Veterans' unique health needs."
        ].cycle
        image_file_names = [
          "tag-suicide-prevention.jpg",
          "tag-homeheatlh.jpg",
          "tag-specialty-care.jpg"
        ]
        sequence :featured_image_file_name, image_file_names.cycle
        sequence :image_alt_text, [
          "VA Secretary Denis McDonough greeting a VA clinic volunteer",
          "A tiny house held by a medical professional wearing gloves and a stethoscope",
          "A man wearing a blood pressure monitor"
        ].cycle
        sequence :featured_image do |n|
          File.new(Rails.root.join('spec', 'assets', 'homepage', image_file_names[n-1] ))
        end
      end
    end

    factory :featured_community do
      sequence(:title) { |n| "Featured Community #{n}" }
      section_id { 3 }
      cta_text { 'View Community' }

      factory :september_community do
        sequence :title, [
          "Age-Friendly",
          "VA Immersive"
        ].cycle
        sequence :description, [
          "Reimagining the landscape of healthcare for our aging Veteran population. ",
          "We help improve care delivery and experiences by leveraging immersive technology for falls risk assessment, neurological risk assessment, pain management, anxiety, addiction recovery, physical therapy, recreation therapy, PTSD, employee education, and more."
        ].cycle
        image_file_names = [
          "community-vr.jpg",
          "community-age-friendly.jpg"
        ]
        sequence :featured_image_file_name, image_file_names.cycle
        sequence :image_alt_text, [
          "A medical professional looks at a tablet with a patient",
          "A person wearing a VR headset and surgical mask"
        ].cycle
        sequence :featured_image do |n|
          File.new(Rails.root.join('spec', 'assets', 'homepage', image_file_names[n-1] ))
        end
      end
    end
  end
end