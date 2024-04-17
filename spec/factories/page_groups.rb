FactoryBot.define do
  factory :page_group do
    name { Faker::Company.unique.name.gsub(/[^a-zA-Z\s]/, '') }
    description { "Description for Sample Page Group" }
    slug { name.parameterize }
  end
end
