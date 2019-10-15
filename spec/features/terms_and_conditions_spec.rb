require 'rails_helper'

describe 'Terms and conditions', type: :feature do
    before do
        @user1 = User.create!(email: 'shunsui.kyoraku@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
        @user2 = User.create!(email: 'yoruichi.shihouin@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    end

    it 'Should display the terms and conditions modal the first time a user logs into the site' do
        login_as(@user1, :scope => :user, :run_callbacks => false)
        visit '/partners'
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content('Partners')
        expect(page).to have_content('Partners Best practices are constantly being developed, vetted, and promoted by offices within the VA.')
        expect(page).to have_content('Terms and conditions')
    end

    it 'Should not display the terms and conditions modal if the user is not signed in' do
        visit '/partners'
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content('Partners')
        expect(page).to have_content('Partners Best practices are constantly being developed, vetted, and promoted by offices within the VA.')
        expect(page).not_to have_content('Terms and conditions')
    end

    it 'Should not display the terms and conditions modal if the user accepts the terms' do
        login_as(@user1, :scope => :user, :run_callbacks => false)
        visit '/partners'
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content('Partners')
        expect(page).to have_content('Partners Best practices are constantly being developed, vetted, and promoted by offices within the VA.')
        expect(page).to have_content('Terms and conditions')
        click_button('I acknowledge the terms')
        expect(page).not_to have_content('Terms and conditions')
    end
end