require 'rails_helper'
describe 'Page Builder - Show - Paginated Components', type: :feature do

  def create_practice_list_components(num = 1,user,page)
    @practices = [
      Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'A cool practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'An awesome practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'An amazing practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'A beautiful practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'A superb practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'The last practice', approved: true, published: true, tagline: 'Test tagline', user: user)
    ]
    pr_ids = @practices.map { |pr| pr[:id].to_s }
    num.times do
      practice_list_component = PagePracticeListComponent.create(practices: pr_ids)
      PageComponent.create(page: page, component: practice_list_component, created_at: Time.now)
    end
  end

  def create_event_components(num = 1, page)
    num.times do
      event_component =  PageEventComponent.create(title: 'Event', url: 'https://wikipedia.org', text: 'event description')
      PageComponent.create(page: page, component: event_component, created_at: Time.now)
    end
  end

  def create_news_components(num = 1, page)
    num.times do
      news_component = PageNewsComponent.create(title: 'News item', url: 'https://wikipedia.org', text: 'news item description', published_date: Date.current.to_s)
      PageComponent.create(page: page, component: news_component, created_at: Time.now)
    end
  end

  before do
    user = User.create!(email: 'sandy.cheeks@va.gov', password: 'Password123',
                        password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    user.add_role(:admin)


    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    Page.create(page_group: page_group, title: 'javascript', description: 'cool stuff', slug: 'javascript', created_at: Time.now, published: Time.now)

    create_practice_list_components(2,user,@page)
    create_event_components(7,@page)
    create_news_components(7,@page)

    # must be logged in to view pages
    login_as(user, scope: :user, run_callbacks: false)
    visit '/programming/ruby-rocks'
  end

  it 'paginates event components', js:true do
    expect(page).to have_css('.page-event-component', count: 3)
    within('.dm-load-more-events-0-btn-container') do
      click_on('Load more')
    end

    expect(page).to have_css('.page-event-component', count: 6)
    within('.dm-load-more-events-0-btn-container') do
      click_on('Load more')
    end

    expect(page).to have_css('.page-event-component', count: 7)
    within('.dm-load-more-events-0-btn-container') do
      expect(page).not_to have_content('Load more')
    end
  end

  it 'paginates news components', js: true do
    expect(page).to have_css('.page-news-component', count: 6)
    within('.dm-load-more-news-items-0-btn-container') do
      click_on('Load more')
    end
    expect(page).to have_css('.page-news-component', count: 7)
    within('.dm-load-more-news-items-0-btn-container') do
       expect(page).not_to have_content('Load more')
    end
  end

  it 'renders a Load More for each component', js: true do
    expect(page).to have_content('Load more', count: 4)
  end

  it 'paginates multiple practice lists', js:true do
    expect(page).to have_css('.dm-practice-card-list', count: 2)
    within('.dm-load-more-practices-0-btn-container') do
      click_on('Load more')
    end
    expect(page).to have_content('The last practice', count: 1)
    within('.dm-load-more-practices-1-btn-container') do
      click_on('Load more')
    end
    expect(page).to have_content('The last practice', count: 2)

    # Events and News should still have load buttons
    expect(page).to have_content('Load more', count: 2)
  end
end
