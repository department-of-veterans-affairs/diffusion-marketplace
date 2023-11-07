require 'rails_helper'

describe 'Page Builder - Show - Paginated Components', type: :feature do
  before do
    page_group = PageGroup.create(
      name: 'programming',
      slug: 'programming',
      description: 'Pages about programming go in this group.'
    )
    page = Page.create(
      page_group: page_group,
      title: 'ruby',
      description: 'what a gem',
      slug: 'ruby-rocks',
      has_chrome_warning_banner: true,
      created_at: Time.now,
      published: Time.now
    )
    component = PageBlockQuoteComponent.create(
      text: 'Bad computer! No! No! Go sit in the corner, and think about your life.',
      citation: 'Anonymous'
    )
    PageComponent.create(page: page, component: component)

    # must be logged in to view pages
    login_as(@user, scope: :user, run_callbacks: false)
  end

  context 'Block Quote Component' do
    it 'displays the block quote text and citation' do
      visit '/programming/ruby-rocks'

      expect(page).to have_content 'Bad computer! No! No! Go sit in the corner, and think about your life.'
      expect(page).to have_content '-Anonymous'
    end
  end
end
