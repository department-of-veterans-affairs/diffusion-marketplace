require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Side navigation' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_overview_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
        end

        it 'should be there' do
            expect(page).to have_css('.usa-sidenav__item', count: 12)
        end

        it 'should not have a link to Collaborators' do
            expect(page).not_to have_link('Collaborators', href: "/practices/#{@practice.slug}/edit/collaborators")
        end

        it 'should navigate the user around the editor when they click on the section names' do
            find('.sidenav-overview-link').click
            expect(page).to have_content('Overview')
            expect(page).to have_content('Introduce your practice and provide a clear overview to people who may be unfamiliar with it.')

            find('.sidenav-documentation-link').click
            expect(page).to have_content('Documentation')
            expect(page).to have_content('File upload')
            expect(page).to have_content('Link attachment')

            find('.sidenav-timeline-link').click
            expect(page).to have_content('Timeline')
            expect(page).to have_content('This section details the estimated timeline for another facility to implement your practice.')
        end

        it 'should show a green check mark next to the section name if all required fields have been filled out' do
            find('.sidenav-timeline-link').click
            expect(page).to_not have_css('.green-check')
            fill_in('Time frame:', with: 'Test timeline')
            fill_in('Milestone:', with: 'Test milestone')
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_css('.green-check', count: 1)
        end

        it 'should save the user\'s progress when the save button is clicked' do
            find('.sidenav-resources-link').click
            expect(all('.resource-radio').first).to_not be_checked
            all('.usa-radio__label').first.click
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(all('.resource-radio').first).to be_checked
        end
    end
end