require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', number_adopted: 1, date_initiated: Date.new(2011, 12, 31), initiating_facility_type: 'facility', overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement')
        @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
        @admin.add_role(User::USER_ROLES[0].to_sym)
        @choose_image_text= 'Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png files less than 32MB. PII/PHI Waivers are required for photos featuring Veterans. Waivers must be filled out with the ‘External to VA’ check box selected.'
    end

    describe 'Overview page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
        end

        def first_metric_field
          find_all('.practice-editor-metric-li').first
        end

        def first_metric_field_input
          first_metric_field.find('input')
        end

        def last_metric_field
          find_all('.practice-editor-metric-li').last
        end

        def last_metric_field_input
          last_metric_field.find('input')
        end

        it 'should allow the user to update the data on the page' do
          # no metrics should be there
          visit '/practices/a-public-practice/edit/overview'
          expect(page).to have_content('Metrics')
          # create one metric and save
          save_button = find('#practice-editor-save-button')
          within(:css, '.practice-editor-metrics-ul') do
            fill_in(first_metric_field_input[:name], with: "Hello world")
          end
          save_button.click
          within(:css, '.practice-editor-metrics-ul') do
            expect(page).to have_field(first_metric_field_input[:name], with: 'Hello world')
          end
          # see if the metric shows up in the show view
          visit '/practices/a-public-practice'
          expect(page).to have_content('Metrics')
          within(:css, '#practice-metrics-ul') do
            expect(page).to have_content('Hello world')
          end

          # go back and edit the metric
          visit practice_overview_path(@practice)
          within(:css, '.practice-editor-metrics-ul') do
            fill_in(first_metric_field_input[:name], with: "Hello world update 1")
          end
          save_button.click
          within(:css, '.practice-editor-metrics-ul') do
            expect(page).to have_field(first_metric_field_input[:name], with: 'Hello world update 1')
          end

          # see if the metric with updated text shows up in the show view
          visit '/practices/a-public-practice'
          expect(page).to have_content('Metrics')
          within(:css, '#practice-metrics-ul') do
            expect(page).to have_content('Hello world update 1')
          end

          # create another metric and save
          visit practice_overview_path(@practice)
          within(:css, '#practice-metrics-container') do
            click_link('Add another')
            fill_in(last_metric_field_input[:name], with: "This is the second metric")
          end
          save_button.click
          within(:css, '.practice-editor-metrics-ul') do
            expect(page).to have_field(first_metric_field_input[:name], with: 'Hello world update 1')
            expect(page).to have_field(last_metric_field_input[:name], with: 'This is the second metric')
          end

          # see if the metrics with updated text shows up in the show view
          visit '/practices/a-public-practice'
          expect(page).to have_content('Metrics')
          within(:css, '#practice-metrics-ul') do
            expect(page).to have_content('Hello world update 1')
            expect(page).to have_content('This is the second metric')
          end

          # delete first metric
          visit practice_overview_path(@practice)
          input_field_id = first_metric_field_input[:id]
          within(:css, "##{first_metric_field[:id]}") do
            click_link('Delete entry')
            expect(page).to_not have_selector("##{input_field_id}")
          end
          save_button.click
          within(:css, '.practice-editor-metrics-ul') do
            expect(page).to have_field(first_metric_field_input[:name], with: 'This is the second metric')
          end

          # see if the metrics with deleted metric does not show up show view
          visit '/practices/a-public-practice'
          expect(page).to have_content('Metrics')
          within(:css, '#practice-metrics-ul') do
            expect(page).to_not have_content('Hello world update 1')
            expect(page).to have_content('This is the second metric')
          end

          # delete "second" metric
          visit practice_overview_path(@practice)
          expect(page).to have_field(first_metric_field_input[:name], with: 'This is the second metric')
          input_field_id = first_metric_field_input[:id]
          within(:css, '#practice-metrics-container') do
            click_link('Add another')
          end
          within(:css, "##{first_metric_field[:id]}") do
            click_link('Delete entry')
            expect(page).to_not have_selector("##{input_field_id}")
          end
          save_button.click
          within(:css, '.practice-editor-metrics-ul') do
            expect(page).to_not have_selector("##{input_field_id}")
          end

          # see if the metrics with deleted metric does not show up show view
          visit '/practices/a-public-practice'
          expect(page).to_not have_content('Metrics')
          expect(page).to_not have_content('This is the second metric')
        end

    end
end