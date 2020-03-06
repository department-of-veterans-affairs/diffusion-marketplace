require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Instructions page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_instructions_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
        end

        it 'should be there' do
            expect(page).to have_content('Create your practice page')
            expect(page).to have_link(href: "mailto:marketplace@va.gov")
        end

        it 'should take the user to the overview page after clicking the continue button' do
            find(".editor-continue-link").click
            wait_for_page_load('Overview')
            expect(page).to have_content('Overview')
            expect(page).to have_current_path(practice_overview_path(@practice))
        end
    end

    def wait_for_page_load(title)
        find('div#overview', text: title)
    end
end
