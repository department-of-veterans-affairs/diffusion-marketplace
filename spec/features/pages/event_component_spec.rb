require 'rails_helper'
  describe 'Page Builder - Show - Paginated Components', type: :feature do
    before do
      page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
      page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)

      start_date_only  = PageEventComponent.create(title: 'Event start date only', start_date: Date.new(2023,05,16))
      date_range_same = PageEventComponent.create(title: 'Event date range 2023', start_date: Date.new(2023,05,16), end_date: Date.new(2023,05,20))
      date_range_diff = PageEventComponent.create(title: 'Event date range 2023 to 2024', start_date:Date.new(2023,05,16), end_date: Date.new(2024,01,01))

      PageComponent.create(page: page, component: start_date_only, created_at: Time.now)
      PageComponent.create(page: page, component: date_range_same, created_at: Time.now)
      PageComponent.create(page: page, component: date_range_diff, created_at: Time.now)

      visit '/programming/ruby-rocks'
    end

    it 'renders events with only a start date' do
      within all('.page-event-component')[0] do
        expect(page).to have_content 'May 16, 2023'
      end
    end

    it 'renders events with a date range in the same year' do
      within all('.page-event-component')[1] do
        expect(page).to have_content 'May 16 - 20, 2023'
      end
    end

    it 'renders events with a date range in different years' do
      within all('.page-event-component')[2] do
        expect(page).to have_content 'May 16, 2023 - January 1, 2024'
      end
    end
end
