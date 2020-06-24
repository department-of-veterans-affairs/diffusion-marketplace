require 'rails_helper'

describe 'Diffusion Marketplace footer', type: :feature, js: true do
  before do
    admin = User.create!(email: 'admin-dmva@example-dmva.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    login_as(admin, :scope => :user, :run_callbacks => false)
    visit practice_overview_path(@practice)
  end

  describe 'Return to top' do
    it 'should exist' do
      within('footer') do
        expect(page).to have_content('Return to top')
      end
    end

    it 'should go to the top of the page on click' do
      scroll_to_bottom
      click_button 'Return to top'
      expect(in_view('header')).to eq(true)
    end
  end

  describe 'footer actions' do
    it 'should exist' do
      within('footer') do
        expect(page).to have_link('Home')
        expect(page).to have_link('Partners')
        expect(page).to have_link('Report a bug')
        expect(page).to have_link('Send feedback')
        expect(page).to have_link('Nominate a practice')
      end
    end
  end

  describe 'footer diffusion marketplace text' do
    it 'should exist' do
      within('footer') do
        expect(page).to have_content('VA | Diffusion Marketplace')
      end
    end
  end
end

def scroll_to_bottom
  page.execute_script "window.scrollTo(0,10000)"
end

# https://stackoverflow.com/questions/49578880/how-to-detect-element-is-present-within-viewport-capybara-ruby
def in_view(element)
  evaluate_script("(function(el) {
    var rect = el.getBoundingClientRect();
    return (
      rect.top >= 0 && rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    )
  })(arguments[0]);", find(element))
end
