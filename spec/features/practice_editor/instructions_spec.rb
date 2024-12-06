require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Editing guide' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_path(@practice)
            expect(page).to be_axe_clean.according_to :wcag2a, :section508
        end

        it 'displays as a modal' do
            click_on('Edit innovation')
            editing_guide = '#dm-editing-guide-modal'
            within(:css, "#dm-practice-editor-header") do
                expect(page).to have_content('Editing guide')
            end

            expect(page).to have_selector(editing_guide, visible: false)
            click_on('Editing guide')
            expect(page).to have_selector(editing_guide, visible: true)

            within(:css, editing_guide) do
                expect(page).to have_content('Follow these instructions to build your innovation page')
                expect(page).to have_content("What you need")
                expect(page).to have_content('Privacy policy')
                expect(page).to have_content('Formatting and editing')
                expect(page).to have_link(href: Constants::FORM_3203_URL)
                expect(page).to have_link(href: Constants::FORM_5345_URL)
            end 

            find('.dm-editing-guide-modal-close').click
            expect(page).to have_selector(editing_guide, visible: false)
      end
    end
end
