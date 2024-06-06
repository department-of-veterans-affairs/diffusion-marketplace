require 'rails_helper'

describe 'Diffusion Marketplace footer', type: :feature, js: true do
  context 'VA user' do
    before do
      admin = User.create!(email: 'admin-dmva@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      admin.add_role(User::USER_ROLES[0].to_sym)
      @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: admin)
      page_group = PageGroup.create(name: 'Open Calls', slug: 'open-calls', description: 'open calls page')
      Page.create(page_group: PageGroup.last, title: 'Vaccine Acceptance Open Calls', description: 'Vaccine Acceptance Open Calls page', slug: 'home', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
      login_as(admin, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
    end

    describe 'Back to top' do
      it 'should exist' do
        within('footer') do
          expect(page).to have_content('Back to Top')
        end
      end
    end

    describe 'footer actions' do
      it 'should exist' do
        within('footer') do
          expect(page).to have_link('Home')
          expect(page).to have_link('Contact us')
          expect(page).to have_link('Nominate an innovation')
          expect(page).to have_link('Choose VA')
          expect(page).to have_link('About VA')
          expect(page).to have_link('Accessibility support')
          expect(page).to have_link('Performance reports')
          expect(page).to have_link('FOIA requests')
          expect(page).to have_link('Disclaimers')
          expect(page).to have_link('Open calls')
          expect(page).to have_link('Terms and conditions')
          expect(page).to have_link('Privacy policy')
          expect(page).to have_link('No FEAR Act data')
          expect(page).to have_link('Whistleblower Protection')
          expect(page).to have_link('Office of the Inspector General')
          expect(page).to have_link('Open data')
          expect(page).to have_link('Vulnerability Disclosure Policy')
          expect(page).to have_link('Visit USA.gov')
        end
      end

      context 'clicking on the open calls link' do
        it 'should redirect to open calls page' do
          click_link('Open calls')
          expect(page).to have_current_path('/open-calls')
        end
      end
    end

    describe 'footer diffusion marketplace text' do
      it 'should exist' do
        within('footer') do
          expect(page).to have_content('An official website of the U.S. Department of Veterans Affairs')
        end
      end
    end
  end
end
