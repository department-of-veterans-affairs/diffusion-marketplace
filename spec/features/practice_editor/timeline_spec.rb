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
            visit practice_implementation_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @time_frame = '5'
            @time_interval = 'Months'
            @milestone = 'Test milestone'
            @add_timeline_step_button = find('#link_to_add_button_timeline')
        end

        fit 'should be there' do
            @save_button = find('#practice-editor-save-button')
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content('Timeline')
            expect(page).to have_content('Add timeline step')
            @add_timeline_step_button.click
            fill_in_timeline_fields
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Time frame', with: "5")
        end

        def fill_in_timeline_fields
            fill_in('Time frame', with: @time_frame)
            select @time_interval, from: 'Time interval'
            fill_in('Description of milestones (include context or disclaimers as needed)', with: @milestone)
        end

        # it 'should allow the user to add multiple timeline entries' do
        #     @add_timeline_step_button.click
        #     fill_in_timeline_fields
        #     debugger
        #     @save_button = find('#practice-editor-save-button')
        #     @save_button.click
        #     find('add-practice-timeline-link').click
        #
        #     all('.timeline-input').last.set('Test timeline 2')
        #     all('.milestone-textarea').last.set('Test milestone 2')
        #     @save_button.click
        #
        #     expect(page).to have_content('Practice was successfully updated')
        #     expect(page).to have_field('practice[timelines_attributes][0][timeline]', with: @time_frame)
        #     expect(page).to have_field('practice[timelines_attributes][0][time_interval]', with: @time_frame)
        #
        #     expect(page).to have_field('practice[timelines_attributes][0][milestone]', with: @milestone)
        #     expect(page).to have_field('practice[timelines_attributes][1][timeline]', with: 'Test timeline 2')
        #     expect(page).to have_field('practice[timelines_attributes][1][milestone]', with: 'Test milestone 2')
        # end

        it 'should allow the user to save timeline entries' do
          @add_timeline_step_button.click
          fill_in_timeline_fields
          @save_practice = find('#practice-editor-save-button')
          @save_practice.click
          expect(page).to have_content('Practice was successfully updated')
        end

        it 'should allow the user to add another timeline entry' do
          @add_timeline_step_button.click
          fill_in_timeline_fields
          @save_practice = find('#practice-editor-save-button')
          @save_practice.click
          @link_to_add = find('#link_to_add_link_timeline')
          @link_to_add.click
          expect(page).to have_content('Practice was successfully updated')
          expect(page).to have_content('Delete entry')
          expect(page).to have_field('Time frame', with: nil)
        end
    end
end