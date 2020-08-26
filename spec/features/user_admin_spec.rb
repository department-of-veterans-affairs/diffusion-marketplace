# frozen_string_literal: true

# User admin specs
require 'rails_helper'

describe 'The user index', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123',
                             password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
  end

  it 'if not logged in, should be redirected to landing page' do
    visit '/users'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Diffusion Marketplace')
  end

  it 'if logged in as a non-admin, should be redirected to landing page' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/users'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Diffusion Marketplace')
  end

  it 'should show all users if logged in as an admin' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Show disabled users')
  end

  it 'should change the users role' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'
    within("form#edit_user_#{User.first.id}") do
      select('Admin', from: "user_#{User.first.id}_role")
      click_button('Assign')
    end
    
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_select("user_#{User.first.id}_role", selected: 'Admin')

    within("form#edit_user_#{User.first.id}") do
      select('User', from: "user_#{User.first.id}_role")
      click_button('Assign')
    end
    visit '/users'
    expect(page).to have_select("user_#{User.first.id}_role", selected: 'User')
  end

  it 'should disable the user' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    expect(page).to have_content('spongebob.squarepants@bikinibottom.net')
    expect(page).to have_css('tbody tr', count: 4)

    accept_alert do
      within("tr#user_row_#{@user.id}") do
        click_button('Disable')
      end
    end

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content("Disabled user \"spongebob.squarepants@bikinibottom.net\"")
    expect(page).to have_css('tbody tr', count: 3)
  end

  it 'should re-enable the user' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    expect(page).to have_content('spongebob.squarepants@bikinibottom.net')
    expect(page).to have_css('tbody tr', count: 4)

    accept_alert do
      within("tr#user_row_#{@user.id}") do
        click_button('Disable')
      end
    end

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content("Disabled user \"spongebob.squarepants@bikinibottom.net\"")
    expect(page).to have_css('tbody tr', count: 3)

    execute_script("$('#show_disabled_users').click()")
    accept_alert do
      within("tr#user_row_#{@user.id}") do
        click_button('Re-enable')
      end
    end

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_css('tbody tr', count: 4)
  end

  it 'should create a new user' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    expect(page).to have_button('Create User')
    expect(page).to have_css('tbody tr', count: 4)

    fill_in('New user email:', with: 'Dummy@email.com')
    click_button('Create User')

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_css('tbody tr', count: 5)
    expect(page).to have_content('dummy@email.com')
  end

  it 'should not try to create a user that already exists' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    fill_in('New user email:', with: 'spongebob.squarepants@bikinibottom.net')
    click_button('Create User')

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content("User with email \"spongebob.squarepants@bikinibottom.net\" already exists")
  end

  it 'should prevent the last admin from being changed' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/users'

    within("form#edit_user_#{@admin.id}") do
      select('User', from: "user_#{@admin.id}_role")
      click_button('Assign')
    end

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_select("user_#{@admin.id}_role", selected: 'Admin')
  end
end
