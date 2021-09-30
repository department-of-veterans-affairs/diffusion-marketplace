require 'rails_helper'

describe 'Diffusion Marketplace header', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'admin-dmva@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
    login_as(@admin, :scope => :user, :run_callbacks => false)
    page_group = PageGroup.create(name: 'competitions', slug: 'competitions', description: 'competitions page')
    Page.create(page_group: page_group, title: 'Shark Tank', description: 'Shark Tank page', slug: 'shark-tank', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    page_group_2 = PageGroup.create(name: 'covid-19', slug: 'covid-19', description: 'covid-19 page')
    visit innovation_overview_path(@practice)
  end

  describe 'header logo' do
    it 'should exist' do
      within('header.usa-header') do
        expect(page).to have_content('VA | Diffusion Marketplace')
        expect(page).to have_link(href: '/')
      end
    end

    it 'should go to the homepage on click' do
      click_on 'VA | Diffusion Marketplace'
      expect(page).to have_current_path('/')
    end
  end

  describe 'header links' do
    it 'should exist' do
      within('header.usa-header') do
        expect(page).to have_content('Diffusion map')
        expect(page).to have_link(href: '/diffusion-map')
        expect(page).to have_content('Shark Tank')
        expect(page).to have_link(href: '/competitions/shark-tank')
        expect(page).to have_content('Your profile')
      end
    end

    context 'clicking on the diffusion map link' do
      it 'should redirect to diffusion map page' do
        click_on 'Diffusion map'
        expect(page).to have_current_path('/diffusion-map')
      end
    end

    context 'clicking on the shark tank link' do
      it 'should redirect to shark tank page' do
        click_on 'Shark Tank'
        expect(page).to have_current_path('/competitions/shark-tank')
      end
    end

    context 'clicking on the profile link' do
      it 'should redirect to user profile page' do
        click_on 'Your profile'
        click_on 'Profile'
        expect(page).to have_selector('.profile-h1 ', visible: true)
        expect(page).to have_current_path('/users/1')
      end
    end

    context 'clicking on the sign out link' do
      it 'should sign the user out' do
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

  describe 'header search' do
    it 'should exist' do
      within('header.usa-header') do
        expect(page).to have_css('#dm-navbar-search-field')
      end
    end

    it 'should redirect to the search results page' do
      within('header.usa-header') do
        fill_in('dm-navbar-search-field', with: 'test')
        find('#dm-navbar-search-button').click
      end

      expect(page).to have_content('1 result')
      expect(page).to have_content('A public practice')
      expect(page).to have_current_path('/search?query=test')
    end
  end

  describe 'Veterans Crisis Line Modal' do
    it 'should allow the user to open the modal and view the contents' do
      visit '/'

      # open the modal
      click_link('Talk to the Veterans Crisis Line now')

      expect(page).to have_content('We’re here anytime, day or night – 24/7')
      expect(page).to have_content('If you are a Veteran in crisis or concerned about one, connect with our caring, qualified responders for confidential help. Many of them are Veterans themselves.')
      expect(page).to have_link('Call 800-273-8255 and select 1')

      # close the modal
      within(:css, '#va-crisis-line-modal') do
        find('.usa-button').click
      end

      expect(page).to_not have_content('We’re here anytime, day or night – 24/7')
      expect(page).to_not have_content('If you are a Veteran in crisis or concerned about one, connect with our caring, qualified responders for confidential help. Many of them are Veterans themselves.')
      expect(page).to_not have_link('Call 800-273-8255 and select 1')
    end
  end
end
