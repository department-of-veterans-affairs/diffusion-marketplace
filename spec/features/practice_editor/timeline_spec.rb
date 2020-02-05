require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Timeline Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_timeline_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
        end

        it 'should be there' do
            expect(page).to have_content('Timeline')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/complexity")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/risk_and_mitigation")
        end

        it 'should require the user to fill out the fields that are marked as required' do
            @save_button.click
            timeline_message = page.find('.timeline-input').native.attribute('validationMessage')
            expect(timeline_message).to eq('Please fill out this field.')
            fill_in('Time frame:', with: 'Test timeline')
            @save_button.click
            milestone_message = page.find('.milestone-textarea').native.attribute('validationMessage')
            expect(milestone_message).to eq('Please fill out this field.')
        end

        it 'should allow the user to add a timeline entry' do
            fill_in('Time frame:', with: 'Test timeline')
            fill_in('Milestone:', with: 'Test milestone')
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('practice[timelines_attributes][0][timeline]', with: 'Test timeline')
            expect(page).to have_field('practice[timelines_attributes][0][milestone]', with: 'Test milestone')
        end

        it 'should allow the user to add multiple timeline entries' do
            fill_in('Time frame:', with: 'Test timeline')
            fill_in('Milestone:', with: 'Test milestone')
            find('.add-timeline-link').click
            all('.timeline-input').last.set('Test timeline 2')
            all('.milestone-textarea').last.set('Test milestone 2')
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('practice[timelines_attributes][0][timeline]', with: 'Test timeline')
            expect(page).to have_field('practice[timelines_attributes][0][milestone]', with: 'Test milestone')
            expect(page).to have_field('practice[timelines_attributes][1][timeline]', with: 'Test timeline 2')
            expect(page).to have_field('practice[timelines_attributes][1][milestone]', with: 'Test milestone 2')
        end

        it 'should allow the user to delete timeline entries' do
            fill_in('Time frame:', with: 'Test timeline')
            fill_in('Milestone:', with: 'Test milestone')
            @save_button.click
            find('.timeline-trash').click
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Time frame:', with: nil)
            expect(page).to have_field('Milestone:', with: nil)
        end
    end
end