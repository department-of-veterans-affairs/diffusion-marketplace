require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Contact Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_contact_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
            @image_path = File.join(Rails.root, '/spec/assets/charmander.png')
            @practice_email = 'test@mail.com'
            @employee_name = 'Test name'
            @employee_role = 'Test role'
            @choose_image_text = 'Choose an image that clearly shows a face. Use a high-quality .jpg, .jpeg, or .png files less than 32MB.'
        end

        it 'should be there' do
            expect(page).to have_content('Contact')
            # expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/risk_and_mitigation")
            # expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/checklist")
            expect(page).to have_content('Upload photo')
            expect(page).to have_content(@choose_image_text)
            expect(page).to have_no_content('Remove photo')
            expect(page).to have_no_content('Edit photo')
            expect(page).to have_no_content('Upload new photo')
            expect(page).to have_no_content('Cancel edits')
            expect(page).to have_no_content('Save edits')
        end

        # it 'should require the user to fill out the fields that are marked as required' do
        #     @save_button.click
        #     email_message = page.find('.contact-email-input').native.attribute('validationMessage')
        #     expect(email_message).to eq('Please fill out this field.')
        #     fill_in('Email:', with: @practice_email)
        #     @save_button.click
        #     contact_name_message = page.find('.va-employee-name-input').native.attribute('validationMessage')
        #     expect(contact_name_message).to eq('Please fill out this field.')
        #     fill_in('Name:', with: @employee_name)
        #     contact_role_message = page.find('.va-employee-role').native.attribute('validationMessage')
        #     expect(contact_role_message).to eq('Please fill out this field.')
        # end

        def fill_in_email_field
            fill_in('Email:', with: @practice_email)
        end

        def fill_in_contact_fields
            fill_in('Name:', with: 'Test name')
            fill_in('Role:', with: 'Test role')
            attach_file('Upload photo', @image_path)
        end

        it 'should allow the user to add a new contact' do
            fill_in_email_field
            fill_in_contact_fields
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_css("img.headshot-img")
            expect(page).to have_field('Name:', with: @employee_name)
            expect(page).to have_field('Role:', with: @employee_role)
            expect(page).to have_content('Upload new photo')
            expect(page).to have_content('Remove photo')
            expect(page).to have_content('Edit photo')
            expect(page).to have_content(@choose_image_text)
            expect(page).to have_no_content('Upload photo')
            expect(page).to have_no_content('Cancel edits')
            expect(page).to have_no_content('Save edits')
        end

        it 'should allow the user to add multiple new contacts' do
            fill_in_email_field
            fill_in_contact_fields
            find('.add-va-employee-link').click

            all('.va-employee-name-input').last.set('Test name 2')
            all('.va-employee-role').last.set('Test role 2')
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_css("img.headshot-img")
            expect(page).to have_field('practice[va_employees_attributes][0][name]', with: @employee_name)
            expect(page).to have_field('practice[va_employees_attributes][0][role]', with: @employee_role)
            expect(page).to have_field('practice[va_employees_attributes][1][name]', with: 'Test name 2')
            expect(page).to have_field('practice[va_employees_attributes][1][role]', with: 'Test role 2')
            expect(page).to have_content('Upload new photo')
            expect(page).to have_content('Remove photo')
            expect(page).to have_content(@choose_image_text)
            expect(page).to have_content('Edit photo')
            expect(page).to have_content('Upload photo')
            expect(page).to have_no_content('Cancel edits')
            expect(page).to have_no_content('Save edits')
        end

        it 'should allow the user to delete contacts' do
            fill_in_email_field
            fill_in_contact_fields
            @save_button.click

            find('.va-employee-trash').click
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Name:', with: nil)
            expect(page).to have_field('Role:', with: nil)
        end
    end
end
