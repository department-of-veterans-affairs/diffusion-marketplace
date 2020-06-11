require 'rails_helper'

describe 'Page Builder - Show', type: :feature do
  before do
    @practices = [
      Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline'),
      Practice.create!(name: 'A cool practice', approved: true, published: true, tagline: 'Test tagline')
    ]
    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', created_at: Time.now, published: Time.now)
    Page.create(page_group: page_group, title: 'javascript', description: 'cool stuff', slug: 'javascript', created_at: Time.now, published: Time.now)
    practice_list_component = PagePracticeListComponent.create(practices: [@practices[0][:id].to_s, @practices[1][:id].to_s,])
    subpage_hyperlink_component = PageSubpageHyperlinkComponent.create(url: '/programming/javascript', title: 'Check out JavaScript', description: 'It is pretty cool too')
    image_path = File.join(Rails.root, '/spec/assets/charmander.png')
    image_file = File.new(image_path)
    image_component = PageImageComponent.create(alignment: 'right', alt_text: 'best pokemon ever', page_image: image_file)
    PageComponent.create(page: page, component: practice_list_component, created_at: Time.now)
    PageComponent.create(page: page, component: subpage_hyperlink_component, created_at: Time.now)
    PageComponent.create(page: page, component: image_component, created_at: Time.now)

    user = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
      password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    user.add_role(:admin)
    # must be logged in to view pages
    login_as(user, scope: :user, run_callbacks: false)
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

  it 'Should display the page image' do
    expect(page).to have_css("img[src*='charmander.png']")
    page.should have_css('.justify-end')
  end
end
