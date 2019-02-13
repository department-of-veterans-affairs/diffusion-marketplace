require 'rails_helper'

describe 'My behaviour', type: :feature do
  describe 'associations' do
    it 'if not logged in, should have the "Register" button' do
      visit '/'
      expect(page).to have_content('Diffusion Marketplace')

      expect(page).to have_selector('a#register-button-link', visible: true)
    end

    it 'if logged in, should not have the "Register" button' do
      user = @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
      login_as(user, :scope => :user, :run_callbacks => false)

      visit '/'
      expect(page).to have_content('Diffusion Marketplace')

      expect(page).not_to have_selector('a#register-button-link')
    end
  end
end