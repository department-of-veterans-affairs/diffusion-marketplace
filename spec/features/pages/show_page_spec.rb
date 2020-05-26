require 'rails_helper'

describe 'Page Builder - Show', type: :feature do
  before do
    @practices = [
      Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline'),
      Practice.create!(name: 'A cool practice', approved: true, published: true, tagline: 'Test tagline')
    ]
    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', created_at: Time.now)
    Page.create(page_group: page_group, title: 'javascript', description: 'cool stuff', slug: 'javascript', created_at: Time.now)
    practice_list_component = PagePracticeListComponent.create(practices: [@practices[0][:id].to_s, @practices[1][:id].to_s,])
    subpage_hyperlink_component = PageSubpageHyperlinkComponent.create(url: '/programming/javascript', title: 'Check out JavaScript', description: 'It is pretty cool too')
    PageComponent.create(page: page, component: practice_list_component, created_at: Time.now )
    PageComponent.create(page: page, component: subpage_hyperlink_component, created_at: Time.now )

    visit '/programming/ruby-rocks'
  end

  it 'Should display the title and description' do
    expect(page).to have_content('ruby')
    expect(page).to have_content('what a gem')
  end

  it 'Should display the practices' do
    expect(page).to have_content('A public practice')
    expect(page).to have_content('A cool practice')
    expect(page).to have_css('.marketplace-card-container')
  end

  it 'Should display the subpage hyperlink' do
    expect(find('.page-subpage-hyperlink')[:href]).to include('/programming/javascript')
    expect(page).to have_content('Check out JavaScript')
    expect(page).to have_content('It is pretty cool too')
  end
end
