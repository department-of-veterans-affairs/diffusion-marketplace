require 'rails_helper'

describe 'Page Builder', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)

    @page_group = PageGroup.create(name: 'programming', description: 'Pages about programming go in this group.')
    @page = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group)

    login_as(@admin, scope: :user, run_callbacks: false)
  end

  def visit_pages_tab_of_admin_panel
    visit '/admin'
    click_link 'Pages'
  end

  describe 'Validations' do
    it 'Should only allow unique page URLs' do
      visit_pages_tab_of_admin_panel
      click_link 'New Page'

      fill_in 'URL', with: 'test-page'
      fill_in 'Title', with: 'Test Page'
      fill_in 'Description', with: 'This page will not get created.'
      select 'programming', from: 'page_page_group_id'

      # bottom create page button
      find('input[name="commit_1"]').click

      expect(page).to have_content('Slug has already been taken')
    end

    it 'Should not allow the user to add a description that is longer than 140 characters' do
      visit_pages_tab_of_admin_panel
      click_link 'New Page'

      fill_in 'URL', with: 'test-page-1'
      fill_in 'Description', with: 'In vehicula leo vitae mattis eleifend. Praesent volutpat ipsum et tincidunt laoreet. Nullam mattis rutrum posuere. Nunc leo neque, molestie nec'
      select 'programming', from: 'page_page_group_id'
      find('input[name="commit_1"]').click

      expect(page).to have_content('Validation failed. Page description cannot be longer than 140 characters.')
      expect(Page.last.slug).to_not eq('test-page-1')
      expect(Page.last.slug).to eq('test-page')
    end
  end

  it 'Should make the page' do
    visit_pages_tab_of_admin_panel

    expect(page).to have_current_path(admin_pages_path)
    click_link 'New Page'

    expect(page).to have_current_path(new_admin_page_path)

    fill_in 'URL', with: 'hello-world'
    fill_in 'Title', with: 'Hello world!'
    fill_in 'Description', with: 'This is the first page built.'
    select 'programming', from: 'page[page_group_id]'

    # bottom create page button
    find('input[name="commit_1"]').click

    expect(page).to have_current_path(admin_page_path(Page.last.id))

    expect(page).to have_content('Hello world!')
    expect(page).to have_content('This is the first page built.')
    expect(page).to have_content('/programming/hello-world')

    # TODO: Figure out how to prevent database cleaning after opening new tab
    # click_link '/programming/hello-world'
  end

  describe 'Page groups' do
    it 'Should create a new page group landing page if the user types home into the url field and chooses a page group' do
      visit_pages_tab_of_admin_panel
      click_link 'New Page'

      fill_in 'URL', with: 'home'
      fill_in 'Title', with: 'Awesome Landing Page'
      fill_in 'Description', with: 'This is an awesome page group landing page.'
      select 'programming', from: 'page_page_group_id'

      # bottom create page button
      find('input[name="commit_1"]').click

      expect(page).to have_current_path(admin_page_path(Page.last.id))
      expect(page).to have_content('Awesome Landing Page')
      expect(page).to have_content('This is an awesome page group landing page')
      expect(page).to have_content('home')
      expect(page).to have_content('/programming')

      # TODO: Figure out how to prevent database cleaning after opening new tab
      # click_link '/programming'
    end
  end
end