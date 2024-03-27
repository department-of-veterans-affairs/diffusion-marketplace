require 'rails_helper'
describe 'Page Builder - Show - Paginated Components - Events', type: :feature, js: true do
  before do
    page_group = create(:page_group, name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = create(:page, page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    @today = Date.current

    @h1 = create(:page_header2_component,subtopic_title: "Visible Upcoming Events")
    create(:page_component, page: @page, component: @h1, position: 1)
    @e1 = create(:page_event_component, title: "upcoming event1", start_date: @today + 5.days, end_date: @today + 7.days, hide_once_passed: true)
    create(:page_component, page: @page, component: @e1, position: 2)
    @e2 = create(:page_event_component, title: "upcoming event2", start_date: @today + 5.days, end_date: @today + 7.days, hide_once_passed: true)
    create(:page_component, page: @page, component: @e2, position: 3)
    @e3 = create(:page_event_component, title: "upcoming event3", start_date: @today + 5.days, end_date: @today + 7.days, hide_once_passed: true)
    create(:page_component, page: @page, component: @e3, position: 4)

    @h2 = create(:page_header2_component,subtopic_title: "Past Events")
    create(:page_component, page: @page, component: @h2, position: 5)
    @e4 = create(:page_event_component, title: "past event1", start_date: @today - 2.days, end_date: @today - 1.days, hide_once_passed: false)
    create(:page_component, page: @page, component: @e4, position: 6)
    @e5 = create(:page_event_component, title: "past event2", start_date: @today - 2.days, end_date: @today - 1.days, hide_once_passed: false)
    create(:page_component, page: @page, component: @e5, position: 7)
    @e6 = create(:page_event_component, title: "past event3", start_date: @today - 2.days, end_date: @today - 1.days, hide_once_passed: false)
    create(:page_component, page: @page, component: @e6, position: 8)

    user = create(:user)
    login_as(user, scope: :user, run_callbacks: false)
  end

  it 'displays events correctly with pagination functionality' do
    visit 'programming/ruby-rocks'

    expect(page).to have_content(@h1.subtopic_title)
    expect(page).to have_content(@e1.title)
    expect(page).to have_content(@e2.title)
    expect(page).not_to have_content(@e3.title)
    page.has_link?('Load more', href: /events-0=2/)
    find('a', text: 'Load more', match: :first).click
    expect(page).to have_content(@e3.title)

    expect(page).to have_content(@h2.subtopic_title)
    expect(page).to have_content(@e4.title)
    expect(page).to have_content(@e5.title)
    expect(page).not_to have_content(@e6.title)
    page.has_link?('Load more', href: /events-1=2/)
    find('a', text: 'Load more', match: :first).click
    expect(page).to have_content(@e6.title)
  end

  it 'hides events once they have passed and are marked as auto-hide and updates pagination' do
    @e3.update!(start_date: @today - 3.days, end_date: @today - 2.days)

    visit 'programming/ruby-rocks'

    expect(page).to have_content(@h1.subtopic_title)
    expect(page).to have_content(@e1.title)
    expect(page).to have_content(@e2.title)
    expect(page).not_to have_content(@e3.title)
    expect(page).to have_no_link('Load more', href: /events-0=2/)

    expect(page).to have_content(@h2.subtopic_title)
    expect(page).to have_content(@e4.title)
    expect(page).to have_content(@e5.title)
    expect(page).not_to have_content(@e6.title)
    page.has_link?('Load more', href: /events-1=2/)
    find('a', text: 'Load more', match: :first).click
    expect(page).to have_content(@e6.title)
  end

  it 'displays text if all events in a group are passed and hidden' do
    [@e1, @e2, @e3].each do |e|
      e.update(start_date: @today - 3.days, end_date: @today - 2.days)
    end

    visit 'programming/ruby-rocks'

    expect(page).to have_content(@h1.subtopic_title)
    expect(page).not_to have_content(@e1.title)
    expect(page).not_to have_content(@e2.title)
    expect(page).not_to have_content(@e3.title)
    expect(page).to have_no_link('Load more', href: /events-0=2/)

    expect(page).to have_content(@h2.subtopic_title)
    expect(page).to have_content(@e4.title)
    expect(page).to have_content(@e5.title)
    expect(page).not_to have_content(@e6.title)
    page.has_link?('Load more', href: /events-1=2/)
    find('a', text: 'Load more', match: :first).click
    expect(page).to have_content(@e6.title)
  end
end

