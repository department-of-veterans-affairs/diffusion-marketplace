require 'rails_helper'
require 'spec_helper'

describe 'Diffusion Marketplace header', type: :feature, js: true do
  before do
    @admin = create(:user, :admin, email: 'naofumi.iwatani@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @non_admin = create(:user, email: 'regular@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = create(:practice, name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, is_public: true, tagline: 'Test tagline', user: @admin)
    create(:practice, name: 'Project HAPPEN', approved: true, published: true, tagline: "HAPPEN tagline", support_network_email: 'test-1232392101@va.gov', user: @admin, maturity_level: 0)
    page_group = create(:page_group, name: 'competitions', slug: 'competitions', description: 'competitions page')
    create(:page, page_group: page_group, title: 'Shark Tank', description: 'Shark Tank page', slug: 'shark-tank', has_chrome_warning_banner: true, created_at: Date.yesterday, is_public: true, published: Date.yesterday)
    page_group_2 = create(:page_group, name: 'covid-19', slug: 'covid-19', description: 'covid-19 page')
    public_community = create(:page_group, name: 'VA Immersive', slug: 'va-immersive', description: 'va-immersive page')
    va_only_community = create(:page_group, name: 'Suicide Prevention', slug: 'suicide-prevention', description: 'Suicide prevention page')
    unpublished_community = create(:page_group, name: 'Age-Friendly', slug: 'age-friendly', description: 'va-immersive page')
    create(:page, page_group: public_community, title: 'VA Immersive', description: 'VA Immersive', slug: 'home', has_chrome_warning_banner: false, is_public: true, created_at: Date.yesterday, published: Date.yesterday)
    create(:page, page_group: va_only_community, title: 'Suicide Prevention homepage', description: 'VA-only home page', slug: 'home', has_chrome_warning_banner: false, created_at: Date.yesterday, is_public: false, published: Date.yesterday)
    create(:page, page_group: unpublished_community, title: 'Age-Friendly homepage', description: 'Unpublished home page', slug: 'home', has_chrome_warning_banner: false, created_at: Date.yesterday, is_public: false, published: nil)
    visit('/')
    page.driver.browser.manage.window.resize_to(1300, 1000)
  end

  describe 'header logo' do
    it 'should exist' do
      within('header.usa-header') do
        expect(page).to have_content(/VA\nDiffusion\nMarketplace/)
        expect(page).to have_link(href: '/')
      end
    end

    it 'should go to the homepage on click' do
      click_on 'Diffusion Marketplace'
      expect(page).to have_current_path('/')
    end
  end

  describe 'header links' do
    it "displays 'Your profile' link for a logged in user" do
      within('header.usa-header') do
        log_in_as_admin_and_visit_homepage
        expect(page).to have_content('About us')
        expect(page).to have_link(href: '/about')
        expect(page).to have_content('Shark Tank')
        expect(page).to have_link(href: '/competitions/shark-tank')
        expect(page).to have_content('Browse by locations')
        expect(page).to have_content('Communities')
        expect(page).to have_content('Your profile')
      end
    end

    it 'Browse by locations' do
      click_on 'Browse by locations'
        within('#browse-by-locations-dropdown') do
        expect(page).to have_content('VISN index')
        expect(page).to have_link(href: '/visns')
        expect(page).to have_content('Facility index')
        expect(page).to have_link(href: '/facilities')
        expect(page).to have_content('Diffusion map')
        expect(page).to have_link(href: '/diffusion-map')
      end
    end

    it "should not display 'Sign in' link for a guest user on a production env" do
      # logout and set the session[:user_type] to 'guest' and add the 'VAEC_ENV' env var to replicate a public guest user on dev/stg/prod
      page.set_rack_session(:user_type => 'guest')
      ENV['VAEC_ENV'] = 'true'
      visit '/'

      within('header.usa-header') do
        expect(page).to have_content('About us')
        expect(page).to have_link(href: '/about')
        expect(page).to have_content('Shark Tank')
        expect(page).to have_link(href: '/competitions/shark-tank')
        expect(page).to have_content('Browse by locations')
        expect(page).to have_content('Communities')
        expect(page).to_not have_content('Sign in')
      end

      ENV['VAEC_ENV'] = nil
    end

    context 'clicking on the profile link' do
      it 'should redirect to user profile page' do
        log_in_as_admin_and_visit_homepage
        click_on 'Your profile'
        click_on 'Profile'
        expect(page).to have_selector('.profile-h1 ', visible: true)
        expect(page).to have_current_path('/users/1')
      end
    end

    context 'clicking on the sign out link' do
      it 'should sign the user out' do
        log_in_as_admin_and_visit_homepage
        click_on 'Your profile'
        click_on 'Sign out'
        expect(page).to have_current_path('/')
        expect(page).to have_content('Signed out successfully.')
        within('header.usa-header') do

        expect(page).to have_content('Sign in')
        expect(page).to have_link(href: '/users/sign_in')
        end
      end
    end
  end

  describe 'Communities dropdown' do
    it 'shows published communities to all users' do
      click_on 'Communities'
      within('#communities-dropdown') do
        expect(page).to have_content('VA Immersive')
        expect(page).not_to have_content('Suicide Prevention')
        expect(page).not_to have_content('Age-Friendly - Admin Preview')
        expect(page).not_to have_link(href: '/communities/suicide-prevention')
        expect(page).not_to have_link(href: '/communities/age-friendly')
      end
    end

    it 'only shows in-progress communities to admins' do
      log_in_as_admin_and_visit_homepage

      click_on 'Communities'
      within('#communities-dropdown') do
      expect(page).to have_content('VA Immersive')
        expect(page).to have_content('Suicide Prevention')
        expect(page).to have_content('Age-Friendly - Admin Preview')
        expect(page).to have_link(href: '/communities/va-immersive')
        expect(page).to have_link(href: '/communities/suicide-prevention')
        expect(page).to have_link(href: '/communities/age-friendly')
      end
    end

    it 'shows soft-launched communities to VA users' do
      login_as(@non_admin, :scope => :user, :run_callbacks => false)
      visit('/')

      click_on 'Communities'
      within('#communities-dropdown') do
        expect(page).to have_content('VA Immersive')
        expect(page).to have_content('Suicide Prevention')
        expect(page).not_to have_content('Admin Preview')
        expect(page).to have_link(href: '/communities/va-immersive')
        expect(page).to have_link(href: '/communities/suicide-prevention')
        expect(page).not_to have_link(href: '/communities/age-friendly')
      end
    end
  end

  describe 'header search' do
    it 'should exist' do
      within('header.usa-header') do
        expect(page).to have_css('#dm-navbar-search-desktop-field')
      end
    end

    it 'should redirect to the search results page' do
      within('header.usa-header') do
        fill_in('dm-navbar-search-desktop-field', with: 'test')
        find('#dm-navbar-search-desktop-button').click
      end

      expect(page).to have_content('1 result')
      expect(page).to have_content('A public practice')
      expect(page).to have_current_path('/search?query=test')

      # should show all published/enabled/approved practices on empty header search
      visit '/'
      within('header.usa-header') do
        find('#dm-navbar-search-desktop-button').click
      end

      expect(page).to have_content('A public practice')
      expect(page).not_to have_content('Project HAPPEN')
    end
  end

  describe 'header mobile' do
    it 'should show the search bar and links' do
      open_mobile_menu
      expect(page).to have_css('.dm-navbar-search-field')
      expect(page).to have_content('About us')
      expect(page).to have_link(href: '/about')
      expect(page).to have_content('Shark Tank')
      expect(page).to have_link(href: '/competitions/shark-tank')
      expect(page).to have_content('Browse by locations')
    end

    it 'shows profile link for logged in users' do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit('/')
      open_mobile_menu
      expect(page).to have_content('Your profile')
    end

    it 'should redirect to the search results page' do
      open_mobile_menu
      fill_in('dm-navbar-search-mobile-field', with: 'test')
      find('#dm-navbar-search-mobile-button').click
      expect(page).to have_content('1 result')
      expect(page).to have_content('A public practice')
      expect(page).to have_current_path('/search?query=test')

      # should show all published/enabled/approved practices on empty header search
      visit '/'
      find('.usa-menu-btn').click
      find('#dm-navbar-search-mobile-button').click
      expect(page).to have_content('A public practice')
      expect(page).not_to have_content('Project HAPPEN')
    end
  end

  describe 'Veterans Crisis Line Modal' do
    it 'should allow the user to open the modal and view the contents' do
      visit '/'

      # open the modal
      click_link('Talk to the Veterans Crisis Line now')

      expect(page).to have_content('We’re here anytime, day or night – 24/7')
      expect(page).to have_content('If you are a Veteran in crisis or concerned about one, connect with our caring, qualified responders for confidential help. Many of them are Veterans themselves.')
      expect(page).to have_link('Call 988 and select 1')

      # close the modal
      within(:css, '#va-crisis-line-modal') do
        find('.usa-button').click
      end

      expect(page).to_not have_content('We’re here anytime, day or night – 24/7')
      expect(page).to_not have_content('If you are a Veteran in crisis or concerned about one, connect with our caring, qualified responders for confidential help. Many of them are Veterans themselves.')
      expect(page).to_not have_link('Call 988 and select 1')
    end
  end

  def open_mobile_menu
      page.driver.browser.manage.window.resize_to(480, 800)
      find('.usa-menu-btn').click
  end

  def log_in_as_admin_and_visit_homepage
    login_as(@admin, :scope => :user, :run_callbacks => false)
    visit('/')
  end
end
