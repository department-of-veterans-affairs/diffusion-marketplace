require 'rails_helper'

describe 'About us page', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    Practice.create!(name: 'Project HAPPEN', approved: true, published: true, tagline: "HAPPEN tagline", support_network_email: 'contact-happen@happen.com', user: @user, maturity_level: 0)
    Practice.create!(name: 'Best Practice Ever', approved: true, published: true, tagline: "The best tagline ever", support_network_email: 'the-best@best.com', user: @user, maturity_level: 0)
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit '/about'
  end

  describe 'Intro section' do
    it '\'Diffusion of Excellence\' link should take the user to the Diffusion of Excellence page at va.gov' do
      expect(page).to be_accessible.according_to :wcag2a, :section508

      new_window = window_opened_by { click_link('Diffusion of Excellence') }
      within_window new_window do
        expect(page).to have_content('VHA Innovation Ecosystem')
        expect(page).to have_content('Diffusion of Excellence')
      end
    end
  end

  describe 'FAQ section' do
    it 'should take the user to the search page with ONLY results that match the maturity level the user clicks on under the \'How does diffusion work?\' question' do
      all('.usa-accordion__heading')[2].click
      click_link('Emerging')
      expect(page).to have_content('Search')
      expect(page).to have_content('2 Results:')
      expect(page).to have_content('Project HAPPEN')
      expect(page).to have_content('Best Practice Ever')
    end

    it 'should take the user to the search page when they click on the \'browsing all innovations\' link under the \'How do I use the Diffusion Marketplace?\' question' do
      all('.usa-accordion__heading')[4].click
      click_link('browsing all innovations')
      # should show all published/enabled/approved practices
      expect(page).to have_content('Search')
      expect(page).to have_content('Project HAPPEN')
      expect(page).to have_content('Best Practice Ever')
    end
  end
end
