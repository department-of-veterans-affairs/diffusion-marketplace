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
            @practice_main_email = 'test@mail.com'
        end

        it 'should be there' do
            expect(page).to have_content('Contact')
            # expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/risk_and_mitigation")
            # expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/checklist")
            expect(page).to have_content('This section helps people to reach out for support, ask questions, and connect about your practice.')
        end

        it 'should require the user to fill out the main email address field' do
            @save_button.click
            email_message = page.find('.main-practice-email-input').native.attribute('validationMessage')
            expect(email_message).to eq('Please fill out this field.')
        end

        def fill_in_main_email_field
            fill_in('main-practice-email-input', with: @practice_main_email)
        end

        def first_cc_email_field
            find_all('.practice-editor-metric-li').first
        end

        def first_cc_email_field_input
            first_metric_field.find('input')
        end

        def last_cc_email_field
            find_all('.practice-editor-metric-li').last
        end

        def last_cc_email_field_input
            last_metric_field.find('input')
        end

        it 'should allow the user to update the email data on the page' do
            # create the main email address
            fill_in_main_email_field
            @save_button.click

            # see if the main email shows up in the show view
            click_link(@practice.name)
            expect(page).to have_content('Email')
            within(:css, '#pr-view-contact') do
                expect(page).to have_content(@practice_main_email)
            end

            # Edit the main email
            visit practice_overview_path(@practice)
            fill_in('Main email address', with: 'main_test@test.com')
            @save_button.click
            expect(page).to have_field('Main email address', with: "main_test@test.com")


            # check if the main email with updated text shows up in the show view
            click_link(@practice.name)
            expect(page).to have_content('main_test@test.com')

            # create one cc email and save
            within(:css, '.practice-editor-contact-ul') do
                fill_in(first_cc_email_field_input[:address], with: 'test2@test.com')
            end
            @save_button.click
            within(:css, '.practice-editor-contact-ul') do
                expect(page).to have_field(first_cc_email_field_input[:address], with: 'test2@test.com')
            end

            # Edit the cc email
            visit practice_overview_path(@practice)
            within(:css, '.practice-editor-contact-ul') do
                fill_in(first_cc_email_field_input[:name], with: "test22@test.com")
            end
            @save_button.click
            within(:css, '.practice-editor-contact-ul') do
                expect(page).to have_field(first_cc_email_field_input[:name], with: "test22@test.com")
            end

            # create another cc email and save
            visit practice_overview_path(@practice)
            within(:css, '#contact_container') do
                click_link('Add another')
                fill_in(last_cc_email_field_input[:address], with: "second_test@test.com")
            end
            @save_button.click
            within(:css, '.practice-editor-contact-ul') do
                expect(page).to have_field(first_cc_email_field_input[:address], with: 'test22@test.com')
                expect(page).to have_field(last_cc_email_field_input[:address], with: 'second_test@test.com')
            end

            # delete first cc email
            visit practice_overview_path(@practice)
            input_field_id = first_cc_email_field_input[:id]
            within(:css, "##{first_cc_email_field[:id]}") do
                click_link('Delete entry')
                expect(page).to_not have_selector("##{input_field_id}")
            end
            @save_button.click
            within(:css, '.practice-editor-contact-ul') do
                expect(page).to have_field(first_cc_email_field_input[:address], with: 'second_test@test.com')
            end

            # delete "second" cc email
            visit practice_overview_path(@practice)
            expect(page).to have_field(first_cc_email_field_input[:name], with: 'second_test@test.com')
            input_field_id = first_cc_email_field_input[:id]
            within(:css, '#contact_container') do
                click_link('Add another')
            end
            within(:css, "##{first_cc_email_field[:id]}") do
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
