require 'rails_helper'

describe 'Diffusion Marketplace header', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'admin-dmva@example-dmva.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    login_as(@admin, :scope => :user, :run_callbacks => false)
    page_group = PageGroup.create(name: 'covid-19', slug: 'covid-19', description: 'Pages about COVID-19 in this group.')
    Page.create(page_group: page_group, title: 'covid home page', description: 'covid practices', slug: 'home', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    visit practice_overview_path(@practice)
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
        expect(page).to have_content('COVID-19')
        expect(page).to have_link(href: '/covid-19')
        expect(page).to have_content('Your profile')
      end
    end

    context 'clicking on the diffusion map link' do
      it 'should redirect to diffusion map page' do
        click_on 'Diffusion map'
        expect(page).to have_current_path('/diffusion-map')
      end
    end

    context 'clicking on the covid-19 link' do
      it 'should redirect to covid-19 page' do
        click_on 'COVID-19'
        expect(page).to have_current_path('/covid-19')
        expect(page).to have_content('covid home page')
      end
    end

    context 'clicking on the profile link' do
      it 'should redirect to user profile page' do
        click_on 'Your profile'
        click_on 'Profile'
        expect(page).to have_current_path(user_path(@admin))
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
end
