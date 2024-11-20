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

  it 'should allow a user to update their public-bio info' do
    @user.update!(granted_public_bio: true)
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/edit-profile'

    fill_in('user[alt_first_name]', with: 'Alt first name')
    fill_in('user[alt_last_name]', with: 'Alt last name')
    fill_in('Title (Public Bio)', with: 'public bio title text')
    fill_in('Credentials (Public Bio)', with: 'public bio credentials text')
    fill_in('Project (Public Bio)', with: 'project text')
    fill_in('Honors, degress (Public Bio)', with: 'LCSW, M.A.')
    click_button('Save changes')

    sb = User.find(@user.id)
    expect(sb.alt_first_name).to eq('Alt first name')
    expect(sb.alt_last_name).to eq('Alt last name')
    expect(sb.alt_job_title).to eq('public bio title text')
    expect(sb.credentials).to eq('public bio credentials text')
    expect(sb.project).to eq('project text')
    expect(sb.accolades).to eq('LCSW, M.A.')
  end

  it 'should allow a user to add, change, and remove their avatar photo' do
    @user.update!(granted_public_bio: true)
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/edit-profile'

    # Initial upload of avatar
    attach_file('user[avatar]', Rails.root.join('app/assets/images/va-seal.png'), visible: false)
    click_button('Save changes')

    # Reload user and verify the avatar was saved
    user = User.find(@user.id)
    expect(user.avatar.present?).to be true

    # Change avatar
    attach_file('user[avatar]', Rails.root.join('app/assets/images/dm-footer-logo.png'), visible: false)
    click_button('Save changes')

    # Reload user and verify the new avatar was saved
    user.reload
    expect(user.avatar.present?).to be true
  end

  it 'should not show public-bio related fields if user not granted access' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/edit-profile'

    expect(page).not_to have_selector("input[value='#{@user.alt_first_name}']")
    expect(page).not_to have_selector("input[value='#{@user.alt_last_name}']")
    expect(page).not_to have_selector("input[value='#{@user.alt_job_title}']")
    expect(page).not_to have_selector("input[value='#{@user.credentials}']")
    expect(page).not_to have_selector("input[value='#{@user.work}']")
    expect(page).not_to have_selector("input[value='#{@user.project}']")
    expect(page).not_to have_selector("input[value='#{@user.accolades}']")
  end

  it 'should link to the public bio page if granted' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/edit-profile'
    expect(page).not_to have_content('Public Bio Page')
    expect(page).not_to have_content('View Public Profile')

    @user.update!(
      granted_public_bio: true,
      first_name: 'John', last_name: 'test',
      alt_last_name: 'Goodman'
    )

    visit '/edit-profile'
    expected_path = '/bios/1-John-Goodman'
    expect(page).to have_link('Public Bio Page', href: expected_path)
    expect(page).to have_link('View Public Profile', href: expected_path)
  end

  it 'should have a favorited practice' do
    @practice1 = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', user: @user)
    @practice2 = Practice.create!(name: 'The Best Innovation Ever!', approved: true, published: true, tagline: 'Test tagline', user: @user2)
    UserPractice.create!(user: @user, practice: @practice2, favorited: true)

    login_as(@user, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"

    within(:css, '.dm-favorited-practices') do
      expect(page).to have_content('The Best Innovation Ever!')
      expect(page).to_not have_content('A public practice')
    end
  end

  it 'should have created practices' do
    @practice1 = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', user: @user)
    @practice2 = Practice.create!(name: 'The Best Innovation Ever!', approved: true, published: true, tagline: 'Test tagline', user: @user2)
    @user_pr1_editor = PracticeEditor.create!(innovable: @practice1, user: @user, email: @user.email)

    login_as(@user, scope: :user, run_callbacks: false)
    visit "/users/#{@user.id}"

    within(:css, '.dm-created-practices') do
      expect(page).to have_content('A public practice')
      expect(page).to have_selector('.dm-practice-card', count: 1)
      expect(page).to_not have_content('The Best Innovation Ever!')
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
    PracticeEditor.create!(innovable: @practice2, user: @user, email: @user.email)
    visit "/users/#{@user.id}"

    within(:css, '.dm-created-practices') do
      expect(page).to have_selector('.dm-practice-card', count: 2)
      expect(page).to have_content('A public practice')
      expect(page).to have_content('The Best Innovation Ever!')
    end
  end

  describe 'work links' do
    before do
      @user.update!(granted_public_bio: true)
      login_as(@user, scope: :user, run_callbacks: false)
      visit '/edit-profile'
    end

    it 'adds a new work entry' do
      fill_in 'user[work][0][text]', with: 'First Project'
      fill_in 'user[work][0][link]', with: 'https://firstproject.com'
      click_button 'Add Another Work Link'
      expect(page).to have_selector('.work-entry', count: 2)
      fill_in 'user[work][1][text]', with: 'Second Project'
      fill_in 'user[work][1][link]', with: 'https://secondproject.com'

      click_button 'Save changes'
      expect(page).to have_content('You successfully updated your profile.')

      visit "/bios/#{@user.id}"
      within('.usa-list--unstyled') do
        expect(page).to have_link('First Project', href: 'https://firstproject.com')
        expect(page).to have_link('Second Project', href: 'https://secondproject.com')
      end
    end

    it 'adds multiple work entries' do
      click_button 'Add Another Work Link'
      fill_in 'user[work][0][text]', with: 'Project One'
      fill_in 'user[work][0][link]', with: 'https://projectone.com'

      click_button 'Add Another Work Link'
      fill_in 'user[work][1][text]', with: 'Project Two'
      fill_in 'user[work][1][link]', with: 'https://projecttwo.com'

      click_button 'Save changes'

      visit "/bios/#{@user.id}"
      within('.usa-list--unstyled') do
        expect(page).to have_link('Project One', href: 'https://projectone.com')
        expect(page).to have_link('Project Two', href: 'https://projecttwo.com')
      end
    end

    it 'removes a work entry' do
      @user.update!(work: {0=>{'text'=> "test link text", 'link' => 'https://projecttwo.com'}})

      visit '/edit-profile'
      within('.work-entry') do
        click_button 'Remove'
      end
      expect(page).to have_button('Add Another Work Link')
      click_button 'Save changes'
      visit "/bios/#{@user.id}"

      expect(page).not_to have_content('Temporary Project')
      expect(page).not_to have_link(href: 'https://temp.com')
    end

    it 'validates the URL format for work entries with front-end validation' do
      click_button 'Add Another Work Link'

      fill_in 'user[work][0][text]', with: 'Invalid Project'
      fill_in 'user[work][0][link]', with: 'invalid-link'

      fill_in 'user[work][0][link]', with: 'invalid-link'

      expect(page).to have_selector("input[name='user[work][0][link]']:invalid")
      click_button 'Save changes'
      expect(page.current_path).to eq('/edit-profile')
    end
  end
end
