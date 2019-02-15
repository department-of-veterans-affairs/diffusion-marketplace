# frozen_string_literal: true

# User admin specs
require 'rails_helper'

describe 'The user index', js: true, type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123',
                             password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
  end

  it 'if not logged in, should be redirected to landing page' do
    visit '/users'
    expect(page).to have_content('Diffusion Marketplace')
  end

  it 'if logged in as a non-admin, should be redirected to landing page' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/users'
    expect(page).to have_content('Diffusion Marketplace')
  end

  it 'should show all users if logged in as an admin' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    expect(page).to have_content('Show disabled users')
  end

  it 'should change the users role' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    within("form#edit_user_#{User.first.id}") do
      select('Admin', from: "user_#{User.first.id}_role")
      click_button('Assign')
    end

    expect(page).to have_select("user_#{User.first.id}_role", selected: 'Admin')
  end

  it 'should disable the user' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    expect(page).to have_content('spongebob.squarepants@bikinibottom.net')
    expect(page).to have_css('tbody tr', count: 4)

    within("tr#user_row_#{User.first.id}") do
      click_button('Delete')
    end

    expect(page).not_to have_content('spongebob.squarepants@bikinibottom.net')
    expect(page).to have_css('tbody tr', count: 3)
  end
end
