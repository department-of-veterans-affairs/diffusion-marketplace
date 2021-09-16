require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Instructions page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_instructions_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
        end

        it 'should have content and links' do
            expect(page).to have_content('Instructions')
            expect(page).to have_content('Please follow these instructions to build your innovation page.')
            expect(page).to have_content("What you'll need")
            expect(page).to have_content('Privacy policy')
            expect(page).to have_content('Formatting and editing')
            expect(page).to have_no_content('Save')
            expect(page).to have_no_content('Publish innovation')
            expect(page).to have_link(href: pii_phi_information_path)
            expect(page).to have_link(href: Constants::FORM_3203_URL)
            expect(page).to have_link(href: Constants::FORM_5345_URL)
            expect(page).to have_link(href: practice_path('project-happen'))
        end
    end
end
