require 'rails_helper'
describe 'Page Builder - Show - Events', type: :feature, js: true do
  before do
    page_group = create(:page_group, name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = create(:page, page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    @event_pagination_size = 3

    user = create(:user)
    login_as(user, scope: :user, run_callbacks: false)
  end

  context 'Hide events after date' do
    it 'displays events correctly with pagination functionality' do
      @h1 = create(:page_header2_component,subtopic_title: "Visible Upcoming Events")
      PageComponent.create(page: @page, component: @h1)
      upcoming_events = create_list(:page_event_component, @event_pagination_size + 1) do |event, i| 
        event.title = "upcoming event #{i + 1}"
        event.start_date = 5.days.from_now
        event.end_date = 7.days.from_now
        event.hide_after_date = true
        event.save
        PageComponent.create(page: @page, component: event)
      end

      @h2 = create(:page_header2_component,subtopic_title: "Past Events")
      PageComponent.create(page: @page, component: @h2)
      past_events = create_list(:page_event_component, @event_pagination_size + 1) do |event, i|
        event.title = "past event #{i + 1}"
        event.start_date = 3.days.ago
        event.end_date = 2.days.ago
        event.hide_after_date = false
        event.save
        PageComponent.create(page: @page, component: event)
      end

      visit 'programming/ruby-rocks'

      @event_pagination_size.times do |i| 
        expect(page).to have_content ("upcoming event #{i + 1}")
        expect(page).to have_content ("past event #{i + 1}")
      end

      expect(page).not_to have_content("upcoming event #{@event_pagination_size + 1}")
      page.has_link?('Load more', href: /events-0=2/)
      find('a', text: 'Load more', match: :first).click
      expect(page).to have_content("upcoming event #{@event_pagination_size + 1}")

      expect(page).not_to have_content("past event #{@event_pagination_size + 1}")
      page.has_link?('Load more', href: /events-1=2/)
      find('a', text: 'Load more', match: :first).click
      expect(page).to have_content("past event #{@event_pagination_size + 1}")
    end

    it 'hides events once they have passed and are marked as auto-hide and updates pagination' do
      @h1 = create(:page_header2_component,subtopic_title: "Visible Upcoming Events")
      PageComponent.create(page: @page, component: @h1)
      expired_event = create(:page_event_component, hide_after_date: true, title: "expired event", start_date: 3.days.ago, end_date: 2.days.ago)
      PageComponent.create(page: @page, component: @expired_event)

      create_list(:page_event_component, @event_pagination_size) do |event, i| # zero index
        event.title = "upcoming event #{i + 1}"
        event.start_date = 5.days.from_now
        event.end_date = 7.days.from_now
        event.hide_after_date = true
        event.save!
        PageComponent.create(page: @page, component: event)
      end

      visit 'programming/ruby-rocks'

      expect(page).not_to have_content(expired_event.title)
      @event_pagination_size.times {|i| expect(page).to have_content("upcoming event #{i + 1}")}
      expect(page).to have_no_link('Load more', href: /events-0=2/)
    end

    it 'displays text if all events in a group are passed and hidden' do
      @h1 = create(:page_header2_component,subtopic_title: "Visible Upcoming Events")
      PageComponent.create(page: @page, component: @h1)

      past_events = create_list(:page_event_component, @event_pagination_size + 1) do |event, i|
        event.title = "expired event #{i + 1}"
        event.start_date = 3.days.ago
        event.end_date = 2.days.ago
        event.hide_after_date = true
        event.save
        PageComponent.create(page: @page, component: event)
      end

      (@event_pagination_size + 1).times { |i| PageComponent.create(page: @page, component: @expired_event)}

      visit 'programming/ruby-rocks'
      expect(page).not_to have_content("expired event")
      expect(page).to have_no_link('Load more', href: /events-0=2/)
      expect(page).to have_content('Please check back for more events soon!')
    end
  end
end

