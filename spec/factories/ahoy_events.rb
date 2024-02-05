FactoryBot.define do
  factory :ahoy_event, class: 'Ahoy::Event' do
    name { 'Category selected' }
    properties { {} }
    time { Time.current }
    visit factory: %i[ahoy_visit]
  end
end
