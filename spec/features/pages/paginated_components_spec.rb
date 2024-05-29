require 'rails_helper'
describe 'Page Builder - Show - Paginated Components', type: :feature do
  before do
    @user = User.create!(email: 'sandy.cheeks@va.gov', password: 'Password123',
                        password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user.add_role(:admin)
    @page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @paragraph_component = PageParagraphComponent.create(text: "<div><p>Just some filler text</p></div>")
    @event_pagination_size = PageEventComponent::PAGINATION
    @news_pagination_size = PageNewsComponent::PAGINATION


    # must be logged in to view pages
    login_as(@user, scope: :user, run_callbacks: false)
  end

  context 'Event components only' do
    before do
      # event components page with 2 lists
      @events_page = Page.create(page_group: @page_group, title: 'events only', description: '2 instances of event list components', slug: 'events-only', created_at: Time.now, published: Time.now)
      create_event_components((@event_pagination_size * 2) + 1, @events_page)
      PageComponent.create(page: @events_page, component: @paragraph_component, created_at: Time.now)
      create_event_components((@event_pagination_size * 2) + 1, @events_page)
      visit 'programming/events-only'
    end

    it 'renders a Load More button for each list', js: true do
      expect(page).to have_content('Load more', count: 2)
    end

    it 'paginates both lists', js: true do
      expect(page).to have_css('.page-event-component', count: @event_pagination_size * 2)

      # load all events in the first list
      click_load_more("events", 0)

      expect(page).to have_css('.page-event-component', count: @event_pagination_size * 3)
      click_load_more("events", 0)
      expect(page).to have_content('Load more')

      expect(page).to have_css('.page-event-component', count: (@event_pagination_size * 3) + 1)
      expect(page).not_to have_css(".dm-load-more-events-0-btn-container > a", text: 'Load more')

      # load all events in the second list
      click_load_more("events", 1)

      expect(page).to have_css('.page-event-component', count: (@event_pagination_size * 4) + 1)
      click_load_more("events", 1)

      expect(page).to have_css('.page-event-component', count: (@event_pagination_size * 4) + 2)
      expect(page).not_to have_css(".dm-load-more-events-1-btn-container > a", text: 'Load more')
    end
  end

  context 'News components only' do
    before do
      # news components page with 2 lists
      @news_page = Page.create(page_group: @page_group, title: 'news only', description: '2 instances of news list components', slug: 'news-only', created_at: Time.now, published: Time.now)
      create_news_components((@news_pagination_size * 2) + 1, @news_page)
      PageComponent.create(page: @news_page, component: @paragraph_component, created_at: Time.now)
      create_news_components((@news_pagination_size * 2) + 1, @news_page)
      visit 'programming/news-only'
    end

    it 'renders a Load More button for each list', js: true do
      expect(page).to have_content('Load more', count: 2)
    end

    it 'paginates both lists', js: true do
      expect(page).to have_css('.page-news-component', count: @news_pagination_size * 2)

      # load all news in the first list
      click_load_more("news", 0)

      expect(page).to have_css('.page-news-component', count: @news_pagination_size * 3)
      click_load_more("news", 0)
      expect(page).to have_content('Load more')

      expect(page).to have_css('.page-news-component', count: (@news_pagination_size * 3) + 1)
      expect(page).not_to have_css(".dm-load-more-news-0-btn-container > a", text: 'Load more')

      # load all news in the second list
      click_load_more("news", 1)

      expect(page).to have_css('.page-news-component', count: (@news_pagination_size * 4) + 1)
      click_load_more("news", 1)

      expect(page).to have_css('.page-news-component', count: (@news_pagination_size * 4) + 2)
      expect(page).not_to have_css(".dm-load-more-news-1-btn-container > a", text: 'Load more')
    end
  end

  context 'mixed components' do
    before do
      # mixed components page with one of each type of list
      @mixed_components_page = Page.create(page_group: @page_group, title: 'ruby', description: 'what a gem', slug: 'mixed-components', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
      Page.create(page_group: @page_group, title: 'javascript', description: 'cool stuff', slug: 'javascript', created_at: Time.now, published: Time.now)

      create_event_components((@event_pagination_size * 2) + 1, @mixed_components_page)
      PageComponent.create(page: @events_page, component: @paragraph_component, created_at: Time.now)
      create_news_components((@news_pagination_size * 2) + 1, @mixed_components_page)
      PageComponent.create(page: @events_page, component: @paragraph_component, created_at: Time.now)
      create_practice_list_components(2,@user,@mixed_components_page)
      visit '/programming/mixed-components'
    end

    it 'paginates event components', js:true do
      expect(page).to have_css('.page-event-component', count: @event_pagination_size)
      click_load_more("events", 0)

      expect(page).to have_css('.page-event-component', count: @event_pagination_size * 2)
      click_load_more("events", 0)

      expect(page).to have_css('.page-event-component', count: (@event_pagination_size * 2) + 1)
      expect(page).not_to have_css(".dm-load-more-events-0-btn-container > a", text: 'Load more')
    end

    it 'paginates news components', js: true do
      expect(page).to have_css('.page-news-component', count: @news_pagination_size)
      click_load_more("news", 0)

      expect(page).to have_css('.page-news-component', count: @news_pagination_size * 2)
      click_load_more("news", 0)
      expect(page).to have_content('Load more')

      expect(page).to have_css('.page-news-component', count: (@news_pagination_size * 2) + 1)
      expect(page).not_to have_css(".dm-load-more-news-0-btn-container > a", text: 'Load more')
    end

    it 'renders a Load More for each component', js: true do
      expect(page).to have_content('Load more', count: 4)
    end

    it 'paginates multiple practice lists', js:true do
      expect(page).to have_css('.dm-practice-card-list', count: 2)
      click_load_more("practices", 0)
      expect(page).to have_content('The last practice', count: 1)
      click_load_more("practices", 1)
      expect(page).to have_content('The last practice', count: 2)

      # Events and News should still have load buttons
      expect(page).to have_content('Load more', count: 2)
    end
  end
end

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
    event_component = create(:page_event_component)
    PageComponent.create(page: page, component: event_component, created_at: Time.now)
  end
end

def create_news_components(num = 1, page)
  num.times do
    news_component = PageNewsComponent.create(title: 'News item', url: 'https://wikipedia.org', text: 'news item description', published_date: Date.current.to_s)
    PageComponent.create(page: page, component: news_component, created_at: Time.now)
  end
end

def click_load_more(component_type, index)
  within(".dm-load-more-#{component_type}-#{index}-btn-container") do
    click_on('Load more')
  end
end
