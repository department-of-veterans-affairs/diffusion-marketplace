FactoryBot.define do
  factory :practice_resource, class: 'PracticeResource' do
    association :practice

    link_url { "http://example.com/resource" }
    name { "Sample Resource Name" }
    description { "Description of the sample resource." }

    transient do
      file_type { "pdf" } # Set the default file type to "pdf"
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

    after(:build) do |practice_resource|
      file_name = practice_resource.attachment_file_name
      practice_resource.attachment = File.new(Rails.root.join('spec', 'assets', file_name))
    end
  end
end

FactoryBot.define do
  factory :practice_problem_resource, parent: :practice_resource, class: 'PracticeProblemResource' do
  end
end

FactoryBot.define do
  factory :practice_results_resource, parent: :practice_resource, class: 'PracticeResultsResource' do
  end
end

FactoryBot.define do
  factory :practice_solution_resource, parent: :practice_resource, class: 'PracticeSolutionResource' do
  end
end
