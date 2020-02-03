require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', implementation_time_estimate: 'longer than 1 year')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Complexity Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_complexity_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
        end

        it 'should be there' do
            expect(page).to have_content('Complexity')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/resources")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/timeline")
        end

        it 'should require the user to fill out the fields that are marked as required' do
            all('.usa-checkbox__label').first.click
            @save_button.click
            expect(accept_alert).to eq('Please choose at least one of the department options listed')
            it_message = all('.it-radio').first.native.attribute('validationMessage')
            expect(it_message).to eq('Please select one of these options.')
        end
    end
end