FactoryBot.define do
  factory :page_group do
    name { "Sample Page Group" }
    description { "Description for Sample Page Group" }
    slug { name.parameterize }
  end
end