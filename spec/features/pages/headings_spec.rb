require 'rails_helper'
describe 'Page Builder - Show - Paginated Components', type: :feature do
  before do
    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)


    # must be logged in to view pages
    login_as(@user, scope: :user, run_callbacks: false)
  end

  # add tests here!
  context 'h2' do
    it 'styles and sets target for external URLs' do
      h2_internal = PageHeader2Component.create(url: '/about', subtopic_title: 'About Our Mission', subtopic_description: 'an internal link')
      h2_external = PageHeader2Component.create(url: 'https://www.google.com', subtopic_title: 'External search', subtopic_description: 'an external link')
      PageComponent.create(page: @page, component: h2_internal, created_at: Time.now)
      PageComponent.create(page: @page, component: h2_external, created_at: Time.now)
      visit '/programming/ruby-rocks'

      internal_link = page.find_link('About Our Mission')
      external_link = page.find_link('External search')

      expect(external_link[:class]).to eq('usa-link usa-link--external')
      expect(external_link[:target]).to eq('_blank')
      expect(internal_link[:class]).not_to eq('usa-link usa-link--external')
      expect(internal_link[:target]).not_to eq('_blank')
    end

    it 'does not apply link styling if a URL is not supplied' do
      h2_plain = PageHeader2Component.create(url: '', subtopic_title: 'Just a Title', subtopic_description: 'no link provided')
      PageComponent.create(page: @page, component: h2_plain, created_at: Time.now)
      visit '/programming/ruby-rocks'

      heading = page.find('h2', text: 'Just a Title')
      expect(heading).not_to have_css('.usa-link')
    end
  end

  context 'h3' do
    it 'styles and sets target for external URLs' do
      h3_internal = PageHeader3Component.create(url: '/about', title: 'About Our Mission', description: 'an internal link', alignment: 'Left')
      h3_external = PageHeader3Component.create(url: 'https://www.google.com', title: 'External search', description: 'an external link', alignment: 'Left')
      PageComponent.create(page: @page, component: h3_internal, created_at: Time.now)
      PageComponent.create(page: @page, component: h3_external, created_at: Time.now)
      visit '/programming/ruby-rocks'

      internal_link = page.find_link('About Our Mission')
      external_link = page.find_link('External search')

      expect(external_link[:class]).to eq('usa-link usa-link--external')
      expect(external_link[:target]).to eq('_blank')
      expect(internal_link[:class]).not_to eq('usa-link usa-link--external')
      expect(internal_link[:target]).not_to eq('_blank')
    end

    it 'does not apply link styling if a URL is not supplied' do
      h3_plain = PageHeader3Component.create(url: '', title: 'Just a Title', description: 'no link provided', alignment: 'Left')
      PageComponent.create(page: @page, component: h3_plain, created_at: Time.now)
      visit '/programming/ruby-rocks'

      heading = page.find('h3', text: 'Just a Title')
      expect(heading).not_to have_css('.usa-link')
    end
  end
end
