FactoryBot.define do
  factory :practice_resource, class: 'PracticeResource' do
    association :practice

    link_url { "http://example.com/resource" }
    name { "Sample Resource Name" }
    description { "Description of the sample resource." }

    attachment_file_name { "dummy.pdf" }
    attachment_content_type { "application/pdf" }
    attachment_file_size { File.size(Rails.root.join('spec', 'assets', 'dummy.pdf')) }
    attachment_updated_at { Time.current }

    after(:build) do |practice_resource|
      practice_resource.attachment = File.new(Rails.root.join('spec', 'assets', 'dummy.pdf'))
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
