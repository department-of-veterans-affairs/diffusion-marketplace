FactoryBot.define do
  factory :page_event_component do
    title { "Event Title" }
    url { "https://example.com" }
    presented_by { "VHA Innovation Network"}
    location { "Virtual" }
    text { "A compelling event description" }
    start_date { Date.new(2024,3,7) }
    end_date {Date.new(2024,3,8) }
  end
end