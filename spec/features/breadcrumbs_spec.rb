require 'rails_helper'

describe 'Breadcrumbs', type: :feature do
  before do
    @pp = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best practices through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
    @user_practice2 = Practice.create!(name: 'Another Best Practice', user: @user, initiating_facility: 'vc_0508V', tagline: 'Test tagline 2')
    login_as(@user, :scope => :user, :run_callbacks => false)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @user_practice)
  end

  describe 'Practice partners flow' do
    it 'should show Practice partners' do
      @user_practice.update(published: true, approved: true)
      visit '/partners'
      expect(page).to be_accessible.according_to :wcag2a, :section508

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Partners')
      end

      click_on('Diffusion of Excellence')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Partners')
        expect(page).to have_content('Diffusion of Excellence')
      end
      
      click_on('The Best Practice Ever!')
      expect(page).to have_current_path(practice_path(@user_practice))

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Partners')
        expect(page).to have_content('Diffusion of Excellence')
        expect(page).to have_content('The Best Practice Ever!')
      end
    end
  end

  describe 'Practices flow' do
    it 'should show proper breadcrumbs when a user visits a practice\'s "next steps"' do
      @user_practice.update(published: true, approved: true)
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Practice Ever!')
      end

      click_on('Take the next step')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Practice Ever!')
        expect(page).to have_content('Planning checklist')
      end
    end
  end

  describe 'Practice Search flow' do
    it 'should show proper breadcrumbs when a user searches for a practice and then visits that practice\'s page' do
      @user_practice.update(published: true, approved: true)
      visit '/'
      fill_in('Search by practice name, facility name, clinical condition, or keyword', with: 'the best')
      
      click_button('practice-search-button')
      expect(page).to have_content('The Best')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')
      end
      click_on('The Best Practice Ever!')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')
        expect(page).to have_content('The Best Practice Ever!')

        # go back to search page
        click_on('Search')
      end
      expect(page).to have_current_path('/search?query=the%20best')

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')

        # go back to homepage
        click_on('Home')
      end

      expect(page).to have_current_path('/')

      # make sure that bug doesn't show up
      fill_in('Search by practice name, facility name, clinical condition, or keyword', with: 'test')
      click_on('Search')
      expect(page).to have_content('test')
      expect(page).to have_current_path('/search?query=test')
      expect(page).to have_field("search", with: "test")
    end
  end

end