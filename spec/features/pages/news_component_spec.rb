require 'rails_helper'
describe 'Page Builder - Show - Paginated Components', type: :feature do
  before do
    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)

    # must be logged in to view pages
    login_as(@user, scope: :user, run_callbacks: false)
  end

  context 'Publication info' do
    it 'date only' do
      news_component = PageNewsComponent.create(title: 'Date only', published_date: Date.new(2023,05,16) )
      PageComponent.create(page: @page, component: news_component, created_at: Time.now)
      visit 'programming/ruby-rocks'

      expect(page).to have_content "Published on May 16, 2023"
    end

    it 'author only' do
      news_component = PageNewsComponent.create(title: 'Author', authors: "Bubbles, Blossom, and Buttercup" )
      PageComponent.create(page: @page, component: news_component, created_at: Time.now,)
      visit 'programming/ruby-rocks'
      expect(page).to have_content "Published by Bubbles, Blossom, and Buttercup"
    end

    it 'date and author' do
      news_component = PageNewsComponent.create(title: 'Date and author', published_date: Date.new(2023,05,16), authors: "Bubbles, Blossom, and Buttercup" )
      PageComponent.create(page: @page, component: news_component, created_at: Time.now,)
      visit 'programming/ruby-rocks'
      expect(page).to have_content "Published on May 16, 2023 by Bubbles, Blossom, and Buttercup"
    end
  end
end
