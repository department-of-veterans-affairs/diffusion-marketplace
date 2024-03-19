require 'rails_helper'
describe 'Page Builder - Show - Paginated Components', type: :feature do
  let(:user) { create(:user) }
  before do
    page_group = create(:page_group,
      name: 'programming', 
      slug: 'programming', 
      description: 'Pages about programming go in this group.',
    )
    page = create(:page,
      page_group: page_group, 
      title: 'ruby', description: 'what a gem', 
      slug: 'ruby-rocks', 
      has_chrome_warning_banner: true, 
      created_at: Time.now, 
      published: Time.now,
    )
    @component = PageTripleParagraphComponent.create(
      title1: 'This is first title', 
      text1: "This is first body",
      title2: "This is second title",
      text2: "This is second body",
      title3: "This is third title",
      text3: "This is third body",
    )
    PageComponent.create(page: page, component: @component)

    login_as(user, scope: :user, run_callbacks: false)
  end

  context 'Titles and paragraphs' do
    it 'displays 3 titles and paragraphs' do
      visit 'programming/ruby-rocks'

      expect(page).to have_content "This is first title"
      expect(page).to have_content "This is first body"
      expect(page).to have_content "This is second title"
      expect(page).to have_content "This is second body"
      expect(page).to have_content "This is third title"
      expect(page).to have_content "This is third body"
    end

    it 'displays component with optional background color' do
      @component.update!(has_background_color: true)

      visit 'programming/ruby-rocks'

      within('div.page-triple-paragraph-component-bg') do
        expect(page).to have_content "This is first title"
        expect(page).to have_content "This is first body"
        expect(page).to have_content "This is second title"
        expect(page).to have_content "This is second body"
        expect(page).to have_content "This is third title"
        expect(page).to have_content "This is third body"
      end
    end
  end
end