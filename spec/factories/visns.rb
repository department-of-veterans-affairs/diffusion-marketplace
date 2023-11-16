FactoryBot.define do
  factory :visn do
    name { Faker::Company.unique.name }
    sequence(:number) do |n|
      num = n
      while Visn.exists?(number: num)
        num += 1
      end
      num
    end
  end
end
