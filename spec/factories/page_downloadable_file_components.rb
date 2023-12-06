FactoryBot.define do
  factory :page_downloadable_file_component do
    display_name { "Sample File" }
    description { "This is a sample file for download." }

    transient do
      file_type { "pdf" }
    end

    attachment_file_name do
      if file_type == "docx"
        "dummy.docx"
      else
        "dummy.pdf"
      end
    end

    attachment_content_type do
      if file_type == "pdf"
        "application/pdf"
      elsif file_type == "docx"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      else
        "application/pdf"
      end
    end

    attachment_file_size { File.size(Rails.root.join('spec', 'assets', attachment_file_name)) }
    attachment_updated_at { Time.current }

    after(:build) do |page_downloadable_file_component|
      file_name = page_downloadable_file_component.attachment_file_name
      page_downloadable_file_component.attachment = File.new(Rails.root.join('spec', 'assets', file_name))
    end
  end
end
