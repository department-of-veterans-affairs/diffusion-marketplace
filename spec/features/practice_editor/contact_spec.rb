require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    describe 'Contact Page' do
        before do
            @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
            @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
            @admin.add_role(User::USER_ROLES[0].to_sym)
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_contact_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
            @practice_main_email = 'test@mail.com'
            @email_field_name = 'practice[practice_emails_attributes][0][address]'
            @email_field_name_2 = 'practice[practice_emails_attributes][1][address]'
        end

        it 'should be there' do
            expect(page).to have_content('Contact')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/implementation")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/about")
            expect(page).to have_content('This section helps people to reach out for support, ask questions, and connect about your practice.')
        end

        it 'should require the user to fill out the main email address field' do
            @save_button.click
            email_message = page.find('.main-practice-email-input').native.attribute('validationMessage')
            expect(email_message).to eq('Please fill out this field.')
        end

        def fill_in_main_email_field
            fill_in('Main email address', with: @practice_main_email)
        end

        def first_cc_email_field_input
            all('.pe-address-input').first
        end

        def first_cc_email_field
            find_all('.practice-editor-contact-li').first
        end

        def last_cc_email_field_input
            all('.pe-address-input').last
        end

        def last_cc_email_field
            find_all('.practice-editor-contact-li').last
        end

        it 'should allow the user to update the email data on the page' do
            # create the main email address
            fill_in_main_email_field
            @save_button.click

            # see if the main email shows up in the show view
            visit '/practices/a-public-practice'
            expect(page).to have_content('Email')
            within(:css, '#contact') do
                expect(page).to have_content(@practice_main_email)
            end

            # Edit the main email
            visit practice_contact_path(@practice)
            fill_in('Main email address', with: 'main_test@test.com')
            @save_button.click
            expect(page).to have_field('Main email address', with: "main_test@test.com")


            # check if the main email with updated text shows up in the show view
            visit '/practices/a-public-practice'
            expect(page).to have_content('main_test@test.com')

            # create one cc email and save
            visit practice_contact_path(@practice)
            first_cc_email_field_input.set('test2@test.com')

            @save_button.click
            expect(page).to have_field(@email_field_name, with: 'test2@test.com')

            # Edit the cc email
            first_cc_email_field_input.set('test22@test.com')
            @save_button.click
            expect(page).to have_field(@email_field_name, with: 'test22@test.com')

            # create another cc email and save
            click_link('Add another')
            last_cc_email_field_input.set('second_test@test.com')

            @save_button.click
            expect(page).to have_field(@email_field_name, with: 'test22@test.com')
            expect(page).to have_field(@email_field_name_2, with: 'second_test@test.com')

            # delete first cc email
            input_field_id = first_cc_email_field_input[:id]
            within(first_cc_email_field) do
                click_link('Delete entry')
                expect(page).to_not have_selector("##{input_field_id}")
            end
            @save_button.click
            within(:css, '.practice-editor-contact-ul') do
                expect(page).to have_field(@email_field_name, with: 'second_test@test.com')
            end

            # delete "second" cc email
            expect(page).to have_field(@email_field_name, with: 'second_test@test.com')
            input_field_id = first_cc_email_field_input[:id]
            within(:css, '#contact_container') do
                click_link('Add another')
            end
            within(first_cc_email_field) do
                click_link('Delete entry')
                expect(page).to_not have_selector("##{input_field_id}")
            end
            @save_button.click
            within(:css, '.practice-editor-contact-ul') do
                expect(page).to_not have_selector("##{input_field_id}")
            end
        end
    end
end
