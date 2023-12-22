FactoryBot.define do
  factory :practice_editor do
    association :practice
    association :user

    after(:build) do |practice_editor|
      practice_editor.email = practice_editor.user.email
    end
  end
end