require 'rails_helper'

describe 'Page Builder', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)

    @page_group = PageGroup.create(name: 'programming', description: 'Pages about programming go in this group.')

    login_as(@admin, scope: :user, run_callbacks: false)
  end

  fit 'Should make the page' do
    visit '/admin'
    click_link 'Pages'

    expect(page).to have_current_path(admin_pages_path)
    click_link 'Create one'

    expect(page).to have_current_path(new_admin_page_path)

    fill_in 'URL', with: 'hello-world'
    fill_in 'Title', with: 'Hello world!'
    fill_in 'Description', with: 'This is the first page built.'
    select 'programming', from: 'page_page_group_id'

    click_button 'Create Page'

    expect(page).to have_current_path(admin_page_path(Page.first.id))

    expect(page).to have_content('Hello world!')
    expect(page).to have_content('This is the first page built.')

    click_link '/programming/hello-world'
    expect(page).to have_current_path('/programming/hello-world')
    expect(page).to have_content('Hello world!')
    expect(page).to have_content('This is the first page built.')

  end


end