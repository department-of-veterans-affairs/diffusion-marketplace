FactoryBot.define do
  factory :practice_resource do
    association :practice

    link_url { "http://example.com/resource" }
    resource { "Sample Resource Identifier" }
    name { "Sample Resource Name" }
    description { "Description of the sample resource." }
    resource_type { PracticeResource.resource_types[:core] }
    media_type { PracticeResource.media_types[:file] }
    resource_type_label { PracticeResource.resource_type_labels[:people] }
    position { 1 }

    attachment_file_name { "dummy.pdf" }
    attachment_content_type { "application/pdf" }
    attachment_file_size { File.size(Rails.root.join('spec', 'assets', 'dummy.pdf')) }
    attachment_updated_at { Time.current }

    # Attach the dummy PDF file
    after(:build) do |practice_resource|
      practice_resource.attachment = File.new(Rails.root.join('spec', 'assets', 'dummy.pdf'))
    end
  end
end
