require 'rails_helper'
describe 'Page Builder - Show - Paginated Components', type: :feature do
  before do
    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)

    # must be logged in to view pages
    login_as(@user, scope: :user, run_callbacks: false)
  end


  context '2 or fewer publications' do
    it 'applies card styling' do
      create_publication_components(2, @page)
      expect(page).to have_css('.page-publication-component', count: 2)
      expect(page).to have_css '.usa-card__container'
    end
  end

  context '3 or more publications' do
    it 'applies list styling' do
      create_publication_components(11, @page)
      visit '/programming/ruby-rocks'
      expect(page).to have_css('.page-publication-component', count: 10)
      # click load more
      click_load_more('publications', 0)
      expect(page).to have_css('.page-publication-component', count: 11)
    end
  end

  context 'Publication' do
    end
  end

  context 'Title' do 
    it 'attached file' do
    end

    it 'url' do
    end

    it 'title only' do
    end
  end


def create_publication_components(num = 1, page)
  num.times do
    publication_component = PagePublicationComponent.create(title: 'News item', url: 'https://wikipedia.org', published_in: 'Journal Title', published_date: Date.current.to_s)
    PageComponent.create(page: page, component: publication_component, created_at: Time.now)
  end
end

def click_load_more(component_type, index)
  within(".dm-load-more-#{component_type}-#{index}-btn-container") do
    click_on('Load more')
  end
end
