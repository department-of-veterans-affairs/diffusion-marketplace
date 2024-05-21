require 'rails_helper'
describe 'Page Builder - Show - Events', type: :feature, js: true do
  before do
    page_group = create(:page_group, name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = create(:page, page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    @event_pagination_size = PageEventComponent::PAGINATION

    user = create(:user)
    login_as(user, scope: :user, run_callbacks: false)
  end

  context 'Hide events after date' do
    it 'displays events correctly with pagination functionality' do
      upcoming_attrs = { start_date: 5.days.from_now, end_date: 7.days.from_now, hide_after_date: true }
      create_events_list("upcoming event", upcoming_attrs)

      @divider = PageHrComponent.create
      PageComponent.create(page: @page, component: @divider)

      past_attrs = { start_date: 3.days.ago, end_date: 2.days.ago, hide_after_date: false }
      create_events_list("past event", past_attrs)

      visit 'programming/ruby-rocks'

      @event_pagination_size.times do |i| 
        expect(page).to have_content ("upcoming event #{i + 1}")
        expect(page).to have_content ("past event #{i + 1}")
      end

      check_pagination('upcoming event',0)
      check_pagination('past event',1)
    end

    it 'hides expired events marked as auto-hide and updates pagination' do
      expired_event = create(:page_event_component, hide_after_date: true, title: "expired event", start_date: 3.days.ago, end_date: 2.days.ago)
      PageComponent.create(page: @page, component: @expired_event)

      upcoming_attrs = { start_date: 5.days.from_now, end_date: 7.days.from_now, hide_after_date: true }
      create_events_list('upcoming event', upcoming_attrs, 0)

      visit 'programming/ruby-rocks'

      expect(page).not_to have_content(expired_event.title)
      @event_pagination_size.times {|i| expect(page).to have_content("upcoming event #{i + 1}")}
      expect(page).to have_no_link('Load more', href: /events-0=2/)
    end

    it 'displays text if all events in a group are passed and hidden' do
      expired_attrs = { start_date: 3.days.ago, end_date: 2.days.ago, hide_after_date: true }
      create_events_list('expired event', expired_attrs)

      (@event_pagination_size + 1).times { |i| PageComponent.create(page: @page, component: @expired_event)}

      visit 'programming/ruby-rocks'
      expect(page).not_to have_content("expired event")
      expect(page).to have_no_link('Load more', href: /events-0=2/)
      expect(page).to have_content('Please check back for more events soon!')
    end
  end

  context 'Link' do
    before do
      @link_testing = @page = create(:page, page_group: @page_group, title: 'link testing', description: 'one component per page', slug: 'link-testing', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    end

    it 'renders nothing for empty URLs' do
      event_component = create(:page_event_component, url: nil, url_link_text: nil)
      PageComponent.create(page: @link_testing, component: event_component, created_at: Time.now,)
      visit 'programming/link-testing'
      expect(page).not_to have_link('View Event')
    end

    it 'renders generic link title if none is provided' do
      event_component = create(:page_event_component, url: '/about', url_link_text: nil)
      PageComponent.create(page: @link_testing, component: event_component, created_at: Time.now,)
      visit 'programming/link-testing'
      expect(page).to have_link('View Event', href: '/about')
    end

    it 'renders custom link title if provided' do
      event_component = create(:page_event_component, url: '/about', url_link_text: 'Register now' )
      PageComponent.create(page: @link_testing, component: event_component, created_at: Time.now,)
      visit 'programming/link-testing'
      expect(page).to have_link('Register now', href: '/about')
      expect(page).not_to have_link('View Event')
    end

    it 'provides aria label with the component title for screenreaders' do
      event_component = create(:page_event_component, title: "Webinar", url: '/about', url_link_text: nil)
      PageComponent.create(page: @link_testing, component: event_component, created_at: Time.now,)
      event_component = create(:page_event_component, title: "Conference", url: '/about', url_link_text: 'Register now' )
      PageComponent.create(page: @link_testing, component: event_component, created_at: Time.now,)
      visit 'programming/link-testing'

      expect(find_link('View Event')[:'aria-label']).to eq('View Event: Webinar')
      expect(find_link('Register now')[:'aria-label']).to eq('Register now: Conference')
    end
  end

    # create just enough components for a "Load more" button
  def create_events_list(event_name, attrs_hash, num_over_pagy_threshold = 1)
    create_list(:page_event_component, @event_pagination_size + num_over_pagy_threshold, attrs_hash) do |event, i|
      event.title = "#{event_name} #{i + 1}"
      event.save
      PageComponent.create(page: @page, component: event)
    end
  end

  # check that load more button shows hidden content
  def check_pagination(event_name, index = 0)
    expect(page).not_to have_content("#{event_name} #{@event_pagination_size + 1}")
      page.has_link?('Load more', href: "/events-#{index}=2/")
      find('a', text: 'Load more', match: :first).click
      expect(page).to have_content("#{event_name} #{@event_pagination_size + 1}")
  end
end

