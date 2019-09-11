# frozen_string_literal: true

# User admin specs
require 'rails_helper'

describe 'The user index', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @user2 = User.create!(email: 'patrick@bikinibottom.net', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
  end

  it 'should not show edit profile button for a different users show page' do
    visit "/users/#{@user.id}"

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to_not have_content('Edit profile')

    login_as(@user2, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"
    expect(page).to_not have_content('Edit profile')    
  end

  it 'should have edit profile button for logged in user' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"
    expect(page).to have_content('Edit profile')
  end

  it 'if not logged in, should be redirected to landing page when accessing account edit' do
    visit '/users/edit/'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Diffusion Marketplace')
    expect(page.current_path).to eq user_session_path
  end

  it 'if not logged in, should be redirected to landing page when accessing profile edit' do
    visit '/edit-profile/'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Diffusion Marketplace')
    expect(page.current_path).to eq user_session_path
  end

  it 'should show the current users email' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/users/edit'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_selector("input[value='#{@user.email}']")
  end

  it 'should allow a user to update their profile' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/edit-profile'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    fill_in('First name', with: 'Spongebob')
    fill_in('Last name', with: 'Squarepants')
    fill_in('Work phone number', with: '8675309')
    fill_in('Job title', with: 'fry cook')
    fill_in('Biography', with: 'Lives in a pineapple')

    click_button('Update')

    sb = User.find(@user.id)
    expect(sb.first_name).to eq('Spongebob')
    expect(sb.last_name).to eq('Squarepants')
    expect(sb.phone_number).to eq('8675309')
    expect(sb.job_title).to eq('fry cook')
    expect(sb.bio).to eq('Lives in a pineapple')
  end

  it 'should allow a user to upload and delete a photo' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/edit-profile'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    click_on('Edit photo')

    attach_file('Photo', Rails.root + 'spec/fixtures/SpongeBob.png')

    click_button('Update')

    sb = User.find(@user.id)
    expect(sb.avatar.present?).to be(true)

    click_on('Edit photo')
    click_on('Remove photo')
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_selector('.empty-user-avatar')
    sb = User.find(@user.id)
    expect(sb.avatar.present?).to be(false)
  end

  it 'should not allow non image files to be uploaded' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/edit-profile'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    click_on('Edit photo')

    attach_file('Photo', Rails.root + 'spec/fixtures/SpongeBob.txt')

    click_button('Update')

    expect(page).to have_content('Avatar content type is invalid')
    expect(page).to have_selector('.empty-user-avatar')
  end
end
