# frozen_string_literal: true

# User admin specs
require 'rails_helper'

describe 'The user index', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick@va.gov', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
  end

  it 'should not show the profile page of a different user and redirect them to the home page' do
    visit "/users/#{@user.id}"

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to_not have_content('Edit profile')
    expect(page.current_path).to eq root_path

    login_as(@user2, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"
    expect(page).to_not have_content('Edit profile')
    expect(page.current_path).to eq root_path
  end

  it 'should have edit profile button for logged in user' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"
    expect(page).to have_selector('.edit-profile-link')
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
    expect(page.current_path).to eq root_path
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
    fill_in('Bio', with: 'Lives in a pineapple')

    click_button('Save changes')

    sb = User.find(@user.id)
    expect(sb.first_name).to eq('Spongebob')
    expect(sb.last_name).to eq('Squarepants')
    expect(sb.phone_number).to eq('8675309')
    expect(sb.job_title).to eq('fry cook')
    expect(sb.bio).to eq('Lives in a pineapple')
  end

  it 'should have a favorited practice' do
    @practice1 = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', featured: true, user: @user)
    @practice2 = Practice.create!(name: 'The Best Practice Ever!', approved: true, published: true, tagline: 'Test tagline', featured: true, user: @user2)
    UserPractice.create!(user: @user, practice: @practice2, favorited: true)

    login_as(@user, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"

    within(:css, '.dm-favorited-practices') do
      expect(page).to have_content('The Best Practice Ever!')
      expect(page).to_not have_content('A public practice')
    end
  end

    it 'should have created practices' do
    @practice1 = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', featured: true, user: @user)
    @practice2 = Practice.create!(name: 'The Best Practice Ever!', approved: true, published: true, tagline: 'Test tagline', featured: true, user: @user2)
    @user_pr1_editor = PracticeEditor.create!(practice: @practice1, user: @user, email: @user.email)

    login_as(@user, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"

    within(:css, '.dm-created-practices') do
      expect(page).to have_content('A public practice')
      expect(page).to have_selector('.dm-practice-card', count: 1)
      expect(page).to_not have_content('The Best Practice Ever!')
    end

    # make user owner of practice1
    @practice1.user = @user
    @practice1.save
    visit "/users/#{@user.id}"

    within(:css, '.dm-created-practices') do
      expect(page).to have_selector('.dm-practice-card', count: 1)
      expect(page).to have_content('A public practice')
    end

    # add user as just an editor of practice2
    PracticeEditor.create!(practice: @practice2, user: @user, email: @user.email)
    visit "/users/#{@user.id}"

    within(:css, '.dm-created-practices') do
      expect(page).to have_selector('.dm-practice-card', count: 2)
      expect(page).to have_content('A public practice')
      expect(page).to have_content('The Best Practice Ever!')
    end
  end
end
