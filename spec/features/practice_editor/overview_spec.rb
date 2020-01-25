require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Overview page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_overview_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
        end

        it 'should be there' do
            expect(page).to have_content('Overview')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/instructions")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/origin")
        end

        it 'should allow the user to update the data on the page' do
            fill_in('practice-editor-name-input', with: 'A super practice')
            fill_in('practice-editor-tagline-textarea', with: 'Super duper')
            select('Alabama', :from => 'editor_state_select')
            select('Birmingham VA Medical Center', :from => 'editor_facility_select')
            fill_in('practice-editor-summary-textarea', with: 'This is the most super practice ever made')
            check('practice_partner_1')
            click_button('Save your progress')
            expect(page).to have_field('practice-editor-name-input', with: 'A super practice')
        end
    end
end