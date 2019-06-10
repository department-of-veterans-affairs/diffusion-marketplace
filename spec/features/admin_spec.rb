# frozen_string_literal: true

# User admin specs
require 'rails_helper'

describe 'The admin dashboard', type: :feature do
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

  # it 'if not logged in, should be redirected to sign_in page' do
  #   visit '/admin'

  #   expect(page).to be_accessible.according_to :wcag2a, :section508
  #   expect(page).to have_current_path(new_user_session_path)
  # end

  # it 'if logged in as a non-admin, should be redirected to landing page' do
  #   login_as(@user, scope: :user, run_callbacks: false)
  #   visit '/admin'

  #   expect(page).to be_accessible.according_to :wcag2a, :section508
  #   expect(page).to have_current_path(root_path)
  #   expect(page).to have_content('Unauthorized Access!')
  # end

  # it 'should show the admin dashboard if logged in as an admin' do
  #   login_as(@admin, scope: :user, run_callbacks: false)
  #   visit '/admin'

  #   expect(page).to be_accessible.according_to :wcag2a, :section508
  #   expect(page).to have_current_path(admin_root_path)
  # end

  # it 'should have several tabs that allow navigation' do
  #   login_as(@admin, scope: :user, run_callbacks: false)
  #   visit '/admin'

  #   expect(page).to be_accessible.according_to :wcag2a, :section508
  #   expect(page).to have_current_path(admin_root_path)

  #   click_link('Dashboard')
  #   expect(page).to have_current_path(admin_dashboard_path)

  #   click_link('Comments')
  #   expect(page).to have_current_path(admin_comments_path)

  #   click_link('Departments')
  #   expect(page).to have_current_path(admin_departments_path)

  #   click_link('Practice Partners')
  #   expect(page).to have_current_path(admin_practice_partners_path)

  #   click_link('Practices')
  #   expect(page).to have_current_path(admin_practices_path)

  #   click_link('Users')
  #   expect(page).to have_current_path(admin_users_path)

  #   click_link('Versions')
  #   expect(page).to have_current_path(admin_versions_path)

  # end

  # it 'should be able to view and update departments' do
  #   login_as(@admin, scope: :user, run_callbacks: false)
  #   visit '/admin'

  #   click_link('Departments')
  #   expect(page).to have_current_path(admin_departments_path)

  #   click_link('New Department')
  #   expect(page).to have_current_path(new_admin_department_path)
  #   fill_in('Name', with: 'Test Department')
  #   fill_in('Short name', with: 'Test')
  #   fill_in('Description', with: 'This is a test department for test purposes.')
  #   click_button('Create Department')
  #   expect(page).to have_current_path(admin_department_path(Department.last))
  #   click_link('Edit Department')
  #   fill_in('Name', with: 'Revised Department')
  #   click_button('Update Department')
  #   expect(page).to have_current_path(admin_department_path(Department.last))
  #   expect(page).to have_content('Revised Department')
  # end

  # it 'should be able to view and update Practice partner' do
  #   login_as(@admin, scope: :user, run_callbacks: false)
  #   visit '/admin'

  #   click_link('Practice Partners')
  #   expect(page).to have_current_path(admin_practice_partners_path)

  #   click_link('New Practice Partner')
  #   expect(page).to have_current_path(new_admin_practice_partner_path)
  #   fill_in('Name', with: 'Test Practice Partner')
  #   fill_in('Short name', with: 'Test')
  #   fill_in('Description', with: 'This is a test practice partner for test purposes.')
  #   click_button('Create Practice partner')
  #   expect(page).to have_current_path(admin_practice_partner_path(PracticePartner.last))
  #   click_link('Edit Practice Partner')
  #   fill_in('Name', with: 'Revised Practice Partner')
  #   click_button('Update Practice partner')
  #   expect(page).to have_current_path(admin_practice_partner_path(PracticePartner.last))
  #   expect(page).to have_content('Revised Practice Partner')
  # end

  # it 'should be able to view Practices and redirec to practice editor' do
  #   Practice.create!
  #   login_as(@admin, scope: :user, run_callbacks: false)
  #   visit '/admin'

  #   click_link('Practices')
  #   expect(page).to have_current_path(admin_practices_path)

  #   within_table('index_table_practices') do
  #     click_link('Edit')
  #   end
  #   expect(page).to have_current_path(edit_practice_path(Practice.last))
  # end

  it 'should be able to view and update Users' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Users')
    expect(page).to have_current_path(admin_users_path)

    click_link('New User')
    expect(page).to have_current_path(new_admin_user_path)
    fill_in('Email', with: 'Test@va.gov')
    fill_in('user_password', with: 'Pass#123')
    fill_in('user_password_confirmation', with: 'Pass#123')
    click_button('Create User')
    expect(page).to have_current_path(admin_user_path(User.last))
  end
end
