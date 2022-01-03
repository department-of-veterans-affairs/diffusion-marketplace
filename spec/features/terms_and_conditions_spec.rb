require 'rails_helper'

describe 'Terms and conditions', type: :feature do
    before do
        @user = User.create!(email: 'shunsui.kyoraku+test1232131@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
        @admin = User.create!(email: 'yoruichi.shihouin+test1232131@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
        @admin.add_role(User::USER_ROLES[1].to_sym)
    end

    def expect_forced_terms_modal
        expect(page).to have_content('Terms and conditions')
        expect(page).to have_content('VA systems are intended to be used by authorized VA network users')
        expect(page).to have_no_css('.usa-modal__close')
    end

    context 'logged in user' do
        it 'Should direct the user to the terms and conditions page the first time the user logs into the site' do
            login_as(@user, :scope => :user, :run_callbacks => false)
            visit '/'
            expect_forced_terms_modal
        end

        it 'Should allow the user to view the site\'s content if the user accepts the terms' do
            login_as(@user, :scope => :user, :run_callbacks => false)
            visit '/'
            expect_forced_terms_modal
            click_button('I acknowledge the terms')
            visit '/partners'
            expect(page).not_to have_content('VA systems are intended to be used by authorized VA network users')
            expect(page).to have_content('Partners')
            expect(page).to have_content('Best innovations are always being developed, vetted, and promoted by offices within the VA.')
            expect(page).to have_current_path('/partners')
            click_link 'Terms and conditions'
            expect(current_path).to eq('/terms-and-conditions')
            expect(page).to have_content('VA systems are intended to be used by authorized VA network users')
            expect(page).to have_no_content('I acknowledge the terms')
            expect(page).to have_content('By continuing to access this website I agree to these terms.')
        end

        it 'Should not allow the user to traverse the app without accepting the terms and conditions' do
            login_as(@user, :scope => :user, :run_callbacks => false)
            visit '/'
            expect_forced_terms_modal
            visit '/partners'
            expect_forced_terms_modal
            expect(page).to have_current_path('/partners')
        end

        it 'Should redirect admin to the home page if they did not accept the terms' do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit '/admin'
            expect_forced_terms_modal
            expect(page).to have_current_path('/')
            click_button('I acknowledge the terms')
            expect(page).not_to have_content('VA systems are intended to be used by authorized VA network users')
            visit '/admin'
            expect(page).to have_current_path('/admin')
        end
    end

    context 'not logged in user' do
        it 'Should not direct the user to the terms and conditions page' do
            visit '/partners'
            expect(page).to have_content('Partners')
            expect(page).to have_content('Best innovations are always being developed, vetted, and promoted by offices within the VA.')
            expect(page).not_to have_content('VA systems are intended to be used by authorized VA network users')
        end

        it 'Should display the terms and conditions page' do
            visit '/partners'
            click_link 'Terms and conditions'
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content('Terms and conditions')
            expect(current_path).to eq('/terms-and-conditions')
            expect(page).to have_content('VA systems are intended to be used by authorized users')
            expect(page).to have_content('By continuing to access this website I agree to these terms.')
            expect(page).to have_no_content('I acknowledge the terms')
        end
    end
end
