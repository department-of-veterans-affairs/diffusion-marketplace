require 'rails_helper'

describe 'Page Builder - Show', type: :feature do
  before do
    practices = [
      Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline'),
      Practice.create!(name: 'A cool practice', approved: true, published: true, tagline: 'Test tagline')
    ]
    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', created_at: Time.now)
    practice_list_component = PagePracticeListComponent.create(practices: [practices[0][:id].to_s, practices[1][:id].to_s,])
    PageComponent.create(page: page, component: practice_list_component, created_at: Time.now )
  end

  it 'Should display the title and description' do
    visit '/programming/ruby-rocks'

    expect(page).to have_content('ruby')
    expect(page).to have_content('what a gem')
  end

  it 'Should display the practices' do
    visit '/programming/ruby-rocks'

    expect(page).to have_content('A public practice')
    expect(page).to have_content('A cool practice')
    expect(page).to have_css('.marketplace-card-container')
  end
end
