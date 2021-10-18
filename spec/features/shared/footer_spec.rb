require 'rails_helper'

describe 'Diffusion Marketplace footer', type: :feature, js: true do
  before do
    admin = User.create!(email: 'admin-dmva@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: admin)
    page_group = PageGroup.create(name: 'Open Calls', slug: 'open-calls', description: 'open calls page')
    Page.create(page_group: page_group, title: 'Vaccine Acceptance Open Calls', description: 'Vaccine Acceptance Open Calls page', slug: 'home', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    login_as(admin, :scope => :user, :run_callbacks => false)
    visit practice_overview_path(@practice)
  end

  describe 'Return to top' do
    it 'should exist' do
      within('footer') do
        expect(page).to have_content('Return to top')
      end
    end
  end

  describe 'footer actions' do
    it 'should exist' do
      within('footer') do
        expect(page).to have_link('Home')
        expect(page).to have_link('Contact us')
        expect(page).to have_link('Nominate an innovation')
        expect(page).to have_link('Open calls')
        expect(page).to have_link('Privacy policy')
        expect(page).to have_link('Terms')
      end
    end

    context 'clicking on the open calls link' do
      it 'should redirect to diffusion map page' do
        click_on 'Open calls'
        expect(page).to have_current_path('/open-calls')
      end
    end
  end

  describe 'footer diffusion marketplace text' do
    it 'should exist' do
      within('footer') do
        expect(page).to have_content('Diffusion Marketplace')
        expect(page).to have_content('Department of Veterans Affairs')
      end
    end
  end
end
