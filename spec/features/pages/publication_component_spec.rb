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
      visit '/programming/ruby-rocks'

      expect(page).to have_css('.page-publication-component', count: 2)
      expect(page).to have_css '.usa-card__container'
      expect(page).not_to have_content('Load more')
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

  context 'Title' do
    it 'links to uploaded PDFs' do
      downloadable_file = File.new(File.join(Rails.root, '/spec/assets/dummy.pdf'))
      publication_component = PagePublicationComponent.create(title: 'Journal article PDF', attachment: downloadable_file, published_in: 'The Journal of Science', published_on_day: 5, published_on_month: 5, published_on_year: 2022)
      PageComponent.create(page: @page, component: publication_component, created_at: Time.now)
      visit '/programming/ruby-rocks'

      expect(page).to have_content('Journal article PDF')
      expect(page).to have_css('.fa-file')
    end

    it 'links to external URLs' do
      publication_component = PagePublicationComponent.create(title: 'External article link', url: 'https://wikipedia.org', published_in: 'Wikipedia', published_on_day: 5, published_on_month: 5, published_on_year: 2022)
      PageComponent.create(page: @page, component: publication_component, created_at: Time.now)
      visit '/programming/ruby-rocks'

      expect(page).to have_content('External article link')
      expect(page).to have_css('.usa-link--external')
    end

    it 'renders the title if no URL or attachment is provided' do
      publication_component = PagePublicationComponent.create(title: 'Placeholder title', published_in: 'Wikipedia', published_on_day: 5, published_on_month: 5, published_on_year: 2022)
      PageComponent.create(page: @page, component: publication_component, created_at: Time.now)
      visit '/programming/ruby-rocks'

      expect(page).to have_content('Placeholder title')
    end
  end

  context 'Published in' do
    it 'renders with appropriate prepositions' do
      publication_and_date = PagePublicationComponent.create(title: 'External article link', url: 'https://wikipedia.org', published_in: 'Wikipedia', published_on_day: 5, published_on_month: 5, published_on_year: 2022)
      publication_only = PagePublicationComponent.create(title: 'External article link', url: 'https://wikipedia.org', published_in: 'Wikipedia')
      date_only = PagePublicationComponent.create(title: 'External article link', url: 'https://wikipedia.org', published_on_day: 5, published_on_month: 5, published_on_year: 2022)
      [publication_and_date, publication_only, date_only].each do |component|
        PageComponent.create(page: @page, component: component, created_at: Time.now)
      end
      visit '/programming/ruby-rocks'

      expect(page).to have_content('Published in Wikipedia on May 5, 2022')
      expect(page).to have_content('Published in Wikipedia')
      expect(page).to have_content('Published on May 5, 2022')
    end
  end

  context 'Publication date' do
    it 'renders with appropriate prepositions and punctuation' do
      full_date = PagePublicationComponent.create(title: 'Full date article', url: 'https://wikipedia.org', published_in: 'Wikipedia', published_on_day: 5, published_on_month: 5, published_on_year: 2022)
      month_and_year = PagePublicationComponent.create(title: 'Month and year article', url: 'https://wikipedia.org', published_in: 'Wikipedia', published_on_month: 5, published_on_year: 2022)
      year_only = PagePublicationComponent.create(title: 'Year only article', url: 'https://wikipedia.org', published_in: 'Wikipedia', published_on_year: 2022)
      [full_date, month_and_year, year_only].each do |component|
        PageComponent.create(page: @page, component: component, created_at: Time.now)
      end

      visit '/programming/ruby-rocks'

      expect(page).to have_content('Published in Wikipedia on May 5, 2022')
      expect(page).to have_content('Published in Wikipedia in May 2022')
      expect(page).to have_content('Published in Wikipedia in May 2022')
    end

    it 'does not render incomplete dates' do
      incomplete_date = PagePublicationComponent.create(title: 'Incomplete date article', url: 'https://wikipedia.org', published_in: 'Wikipedia', published_on_day: 5, published_on_month: 5)
      PageComponent.create(page: @page, component: incomplete_date, created_at: Time.now)
      visit '/programming/ruby-rocks'

      expect(page).to have_content('Published in Wikipedia')
    end
  end
end


def create_publication_components(num = 1, page)
  num.times do
    publication_component = PagePublicationComponent.create(title: 'News item', url: 'https://wikipedia.org', published_in: 'Journal Title', published_on_day: 5, published_on_month: 5, published_on_year: 2022)
    PageComponent.create(page: page, component: publication_component, created_at: Time.now)
  end
end

def click_load_more(component_type, index)
  within(".dm-load-more-#{component_type}-#{index}-btn-container") do
    click_on('Load more')
  end
end
