require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @pr_no_resources = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement')
    @pr_with_resources = Practice.create!(name: 'A practice with resources', slug: 'practice-with-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement')
    file_path_1 = "#{Rails.root}/spec/assets/dummy.pdf"
    @problem_resource = PracticeProblemResource.create(practice: @pr_with_resources, name: 'existing problem file', description: 'problem file description', attachment: File.new(file_path_1), resource_type: 2)
    @problem_resource = PracticeSolutionResource.create(practice: @pr_with_resources, name: 'existing solution file', description: 'solution file description', attachment: File.new(file_path_1), resource_type: 2)
    @problem_resource = PracticeResultsResource.create(practice: @pr_with_resources, name: 'existing results file', description: 'results file description', attachment: File.new(file_path_1), resource_type: 2)
    @file_path_2 = "#{Rails.root}/spec/assets/SpongeBob.txt"
    @file_path_3 = "#{Rails.root}/spec/assets/charmander.png"
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Overview page -- resource file:' do
    describe 'default view' do
      context 'with no saved resources' do
        before do
          no_resource_pr_test_setup
        end

        it 'should not display the file resource form' do
          expect(page).to have_no_content("Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.")
          expect(page).to have_no_content('File name')
          expect(page).to have_no_content('File description')
          expect(page).to have_no_css('#problem_resources_file_form')
          expect(page).to have_no_css('#solution_resources_file_form')
          expect(page).to have_no_css('#results_resources_file_form')
        end
      end

      context 'with saved resources' do
        before do
          with_resource_pr_test_setup
        end

        def saved_file_display_test(area)
          within(:css, "##{area}_section") do
            expect(page).to have_content('FILES')
            expect(page).to have_content('dummy.pdf')
            expect(find_field('File name').value).to eq("existing #{area} file")
            expect(find_field('File description').value).to eq("#{area} file description")
            expect(page).to have_content('Delete entry')
          end
        end

        it 'should display the saved file resources' do
          saved_file_display_test 'problem'
          saved_file_display_test 'solution'
          saved_file_display_test 'results'
        end
      end
    end

    describe 'complete and add file' do
      before do
        no_resource_pr_test_setup
      end

      def cancel_form(area)
        find("#cancel_#{area}_resources_file").click
      end

      def complete_add_file_test(area)
        within(:css, "##{area}_section") do
          click_file_form area
          expect(page).to have_content("Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.")
          expect(page).to have_content('File name')
          expect(page).to have_content('File description')
          expect(page).to have_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          add_resource
          expect(error_msg_val).to eq 'Please upload a file.'
          upload_file(area, @file_path_2)
          add_resource
          expect(error_msg_val).to eq 'Please enter a file name.'
          fill_in('File name', with: 'new file')
          add_resource
          expect(error_msg_val).to eq 'Please enter a file description.'
          fill_in('File description', with: "new practice #{area} file")
          add_resource
          expect(find_all('.overview_error_msg').length).to eq 0

          within(:css, "##{area}_resources_file_form") do
            expect(page).to have_content('Drag file here or choose from folder')
            expect(name_field.value).to eq ''
            expect(description_field.value).to eq ''
          end
          cancel_form area
          expect(page).to have_no_css("##{area}_resources_file_form")
        end

        within(:css, "#display_#{area}_resources_file") do
          expect(page).to have_content('SpongeBob.txt')
          expect(page).to have_content('FILES')
          expect(name_field.value).to eq('new file')
          expect(description_field.value).to eq("new practice #{area} file")
          expect(page).to have_content('Delete entry')
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_content("Files")
        expect(page).to have_content("new file")
        expect(page).to have_content("new practice #{area} file")
      end

      it 'problem section - should save file' do
        complete_add_file_test 'problem'
      end

      it 'solution section - should save file' do
        complete_add_file_test 'solution'
      end

      it 'results section - should save file' do
        complete_add_file_test 'results'
      end
    end

    describe 'edit newly added files' do
      before do
        no_resource_pr_test_setup
      end

      def edit_added_file_test(area)
        within(:css, "##{area}_section") do
          click_file_form area
          upload_file(area, @file_path_2)
          fill_in('File name', with: 'new file')
          fill_in('File description', with: "new practice #{area} file")
          add_resource
        end

        within(:css, "#display_#{area}_resources_file") do
          expect(page).to have_content('SpongeBob.txt')
          expect(name_field.value).to eq('new file')
          expect(description_field.value).to eq("new practice #{area} file")
          upload_file(area, @file_path_3)
          name_field.set('edited file')
          description_field.set("edited practice #{area} file")
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_content("edited file")
        expect(page).to have_content("edited practice #{area} file")
      end

      it 'problem section - should allow user to edit newly added files' do
        edit_added_file_test 'problem'
      end

      it 'solution section - should allow user to edit newly added files' do
        edit_added_file_test 'solution'
      end

      it 'results section - should allow user to edit newly added files' do
        edit_added_file_test 'results'
      end
    end

    describe 'edit existing files' do
      before do
        with_resource_pr_test_setup
      end

      def edit_existing_file_test(area)
        within(:css, "#display_#{area}_resources_file") do
          name_field.set('edited file')
          description_field.set("edited practice #{area} file")
        end

        save_practice
        visit practice_path(@pr_with_resources)
        expect(page).to have_content('edited file')
        expect(page).to have_content("edited practice #{area} file")
        expect(page).to have_no_content("#{area} file description")
        expect(page).to have_no_content("existing #{area} file")
      end

      it 'problem section - should allow user to edit existing files' do
        edit_existing_file_test 'problem'
      end

      it 'solution section - should allow user to edit existing files' do
        edit_existing_file_test 'solution'
      end

      it 'results section - should allow user to edit existing files' do
        edit_existing_file_test 'results'
      end
    end

    describe 'delete new and existing files' do
      before do
        with_resource_pr_test_setup
      end

      def delete_entries_test(area)
        within(:css, "#display_#{area}_resources_file") do
          click_button('Delete entry')
          expect(page).to have_no_content("existing #{area} file")
          expect(page).to have_no_content("#{area} file description")
        end

        within(:css, "##{area}_section") do
          click_file_form area
          upload_file(area, @file_path_2)
          fill_in('File name', with: 'new file')
          fill_in('File description', with: "new practice #{area} file")
          add_resource
        end

        within(:css, "#display_#{area}_resources_file") do
          expect(name_field.value).to eq('new file')
          expect(description_field.value).to eq("new practice #{area} file")
          click_button('Delete entry')
        end

        save_practice
        visit practice_overview_path(@pr_with_resources)
        expect(page).to have_no_content("existing #{area} file")
        expect(page).to have_no_content("#{area} file description")
        expect(page).to have_no_content('new file')
        expect(page).to have_no_content("new practice #{area} file")
      end

      it 'problem section - should allow user to delete existing files' do
        delete_entries_test 'problem'
      end

      it 'solution section - should allow user to delete existing files' do
        delete_entries_test 'solution'
      end

      it 'results section - should allow user to delete existing files' do
        delete_entries_test 'results'
      end
    end
    # canceling form - should clear it and errors
  end
end

def name_field
  find_all('input[type="text"][class="usa-input"]').first
end

def description_field
  find_all('input[type="text"][class="usa-input"]').last
end

def click_file_form(area)
  find("label[for=practice_#{area}_file]").click
end

def upload_file(area, file)
  find_all('input[type="file"]').first.attach_file(file)
end

def add_resource
  find('.add-resource').click
end

def save_practice
  find('#practice-editor-save-button').click
end

def error_msg_val
  find_all('.overview_error_msg').first.value
end

def no_resource_pr_test_setup
  visit practice_path(@pr_no_resources)
  expect(page).to have_content('Overview')
  expect(page).to have_no_content("Files")
  visit practice_overview_path(@pr_no_resources)
end

def with_resource_pr_test_setup
  visit practice_path(@pr_with_resources)
  expect(page).to have_content('Overview')
  expect(page).to have_content("Files")
  expect(has_link?("existing problem file")).to eq(true)
  expect(has_link?("existing solution file")).to eq(true)
  expect(has_link?("existing results file")).to eq(true)
  expect(page).to have_content("problem file description")
  expect(page).to have_content("solution file description")
  expect(page).to have_content("results file description")
  visit practice_overview_path(@pr_with_resources)
end
