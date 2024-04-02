FactoryBot.define do
  factory :page_block_quote_component do
    text { "<p>This is a block quote text.</p>" }
    citation { "<p>Author Name</p>" }

    after(:build) do |component|
      component.page_component ||= build(:page_component, component: component)
    end
  end
end