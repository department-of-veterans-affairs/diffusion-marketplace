require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
        @departments = [
            Department.create!(name: 'Admissions', short_name: 'admissions'),
            Department.create!(name: 'Medical', short_name: 'none'),
        ]
    end

    describe 'Complexity Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_complexity_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
            @staff_title = 'staff title'
            @staff_hours = '3'
            @staff_permanent = all('.permanent-staff-label').first
            @staff_duration = '2'
            @staff_training_title = 'staff training title'
            @staff_training_description = 'staff description'
            @training_length = '2'
        end

        it 'should be there' do
            expect(page).to have_content('Complexity')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/resources")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/timeline")
        end

        # it 'should require the user to fill out the fields that are marked as required' do
        #     @save_button.click
        #     it_message = all('.it-radio').first.native.attribute('validationMessage')
        #     expect(it_message).to eq('Please select one of these options.')
        #     all('.complexity-it-label').first.click
        #     @save_button.click
        #     process_message = all('.process-radio').first.native.attribute('validationMessage')
        #     expect(process_message).to eq('Please select one of these options.')
        #     all('.complexity-process-label').first.click
        #     @save_button.click
        #     time_estimate_message = all('.time-estimate-radio').first.native.attribute('validationMessage')
        #     expect(time_estimate_message).to eq('Please select one of these options.')
        #     all('.time-estimate-label').first.click
        #     @save_button.click
        #     training_required_message = all('.training-required-radio').first.native.attribute('validationMessage')
        #     expect(training_required_message).to eq('Please select one of these options.')
        #     all('.need_training_true_label').first.click
        #     @save_button.click
        #     training_length_message = find('.training-length-input').native.attribute('validationMessage')
        #     expect(training_length_message).to eq('Please fill out this field.')
        #     find('.training-length-input').set(@training_length)
        #     @save_button.click
        #     staff_title_message = find('.staff-training-title').native.attribute('validationMessage')
        #     expect(staff_title_message).to eq('Please fill out this field.')
        #     find('.staff-training-title').set(@staff_training_title)
        #     @save_button.click
        #     staff_description_message = find('.staff-training-description').native.attribute('validationMessage')
        #     expect(staff_description_message).to eq('Please fill out this field.')
        #     find('.staff-training-description').set(@staff_training_description)
        #     @save_button.click
        #     expect(accept_alert).to eq('Please choose at least one of the department options listed')
        # end

        def fill_in_required_fields
            all('.complexity-it-label').first.click
            all('.complexity-process-label').first.click
            all('.time-estimate-label').first.click
            all('.need_training_true_label').first.click
            find('.training-length-input').set(@training_length)
        end

        def fill_in_additional_staff_fields
            find('.staff-title-input').set(@staff_title)
            find('.staff-hours-input').set(@staff_hours)
            @staff_permanent.click
            find('.staff-duration-input').set(@staff_duration)
        end

        def fill_in_required_staff_training_fields
            find('.staff-training-title').set(@staff_training_title)
            find('.staff-training-description').set(@staff_training_description)
        end

        def check_department_fields
            find('label[for=practice_department_1]').click
            find('label[for=practice_department_2]').click
        end

        it 'should allow the user to add an additional staff member and required staff training' do
            fill_in_required_fields
            fill_in_additional_staff_fields
            fill_in_required_staff_training_fields
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('practice[additional_staffs_attributes][0][title]', with: @staff_title)
            expect(page).to have_field('practice[additional_staffs_attributes][0][hours_per_week]', with: @staff_hours)
            expect(all('.permanent-radio').first).to be_checked
            expect(page).to have_field('practice[additional_staffs_attributes][0][duration_in_weeks]', with: @staff_duration)
            expect(page).to have_field('practice[required_staff_trainings_attributes][0][title]', with: @staff_training_title)
            expect(page).to have_field('practice[required_staff_trainings_attributes][0][description]', with: @staff_training_description)
        end

        it 'should allow the user to add multiple additional staff members and required staff trainings' do
            fill_in_required_fields
            fill_in_additional_staff_fields
            find('.add-additional-staff-link').click

            all('.staff-title-input').last.set('title 2')
            all('.staff-hours-input').last.set('4')
            all('.permanent-staff-label').last.click
            all('.staff-duration-input').last.set('3')

            fill_in_required_staff_training_fields
            find('.add-required-staff-link').click

            all('.staff-training-title').last.set('staff title 2')
            all('.staff-training-description').last.set('Teach the trainee how to be extra awesome')
            @save_button.click
            
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('practice[additional_staffs_attributes][0][title]', with: @staff_title)
            expect(page).to have_field('practice[additional_staffs_attributes][0][hours_per_week]', with: @staff_hours)
            expect(all('.permanent-radio').first).to be_checked
            expect(page).to have_field('practice[additional_staffs_attributes][0][duration_in_weeks]', with: @staff_duration)
            expect(page).to have_field('practice[required_staff_trainings_attributes][0][title]', with: @staff_training_title)
            expect(page).to have_field('practice[required_staff_trainings_attributes][0][description]', with: @staff_training_description)

            expect(page).to have_field('practice[additional_staffs_attributes][1][title]', with: 'title 2')
            expect(page).to have_field('practice[additional_staffs_attributes][1][hours_per_week]', with: '4')
            expect(all('.permanent-radio').last).to be_checked
            expect(page).to have_field('practice[additional_staffs_attributes][1][duration_in_weeks]', with: '3')
            expect(page).to have_field('practice[required_staff_trainings_attributes][1][title]', with: 'staff title 2')
            expect(page).to have_field('practice[required_staff_trainings_attributes][1][description]', with: 'Teach the trainee how to be extra awesome')
        end

        it 'should allow the user to delete additional staff members and required staff trainings' do
            fill_in_required_fields
            fill_in_additional_staff_fields
            fill_in_required_staff_training_fields
            @save_button.click

            all('.staff-trash').first.click
            all('.staff-trash').last.click
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Role', with: nil)
            expect(page).to have_field('Hours per week', with: nil)
            expect(all('.permanent-radio').first).to_not be_checked
            expect(page).to have_field('Role duration', with:  nil)
            expect(page).to have_field('Job Title', with: nil)
            expect(page).to have_field('Description', with: nil)
        end

        it 'should allow the user to add and remove departments' do
            fill_in_required_fields
            fill_in_required_staff_training_fields
            check_department_fields
            @save_button.click
            expect(page).to have_checked_field('practice_department_1', visible: false)
            expect(page).to have_checked_field('practice_department_2', visible: false)
        end
    end
end