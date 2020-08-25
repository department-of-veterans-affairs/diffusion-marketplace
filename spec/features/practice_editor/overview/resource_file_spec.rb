require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @pr_no_resources = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31))
    @pr_with_resources = Practice.create!(name: 'A practice with resources', slug: 'practice-with-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31))
    file_path_1 = "#{Rails.root}/spec/assets/dummy.pdf"
    @problem_resource = PracticeProblemResource.create(practice: @pr_with_resources, name: 'file one', description: 'problem file description', attachment: File.new(file_path_1), resource_type: 2)
    @problem_resource = PracticeSolutionResource.create(practice: @pr_with_resources, name: 'file two', description: 'solution file description', attachment: File.new(file_path_1), resource_type: 2)
    @problem_resource = PracticeResultsResource.create(practice: @pr_with_resources, name: 'file three', description: 'results file description', attachment: File.new(file_path_1), resource_type: 2)
    @file_path_2 = "#{Rails.root}/spec/assets/SpongeBob.txt"
    @file_path_3 = "#{Rails.root}/spec/assets/charmander.png"
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Overview page -- resource file:' do
    describe 'default view' do
      context 'with no saved resources' do
        before do
          visit practice_overview_path(@pr_no_resources)
        end

        it 'should not display the file resource form' do
          expect(page).to have_no_content("Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.")
          expect(page).to have_no_content('File name')
          expect(page).to have_no_content('File description')
          expect(page).to have_no_css('#problem_resources_file_form')
          expect(page).to have_no_css('#solution_resources_file_form')
          expect(page).to have_no_css('#results_resources_file_form')
          within(:css, '#problem_section') do
            expect(page).to have_no_content('FILES')
            expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          end
          within(:css, '#solution_section') do
            expect(page).to have_no_content('FILES')
            expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          end
          within(:css, '#results_section') do
            expect(page).to have_no_content('FILES')
            expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          end
        end

        it 'should not display any file resources' do
          within(:css, '#problem_section') do
            expect(page).to have_no_content('FILES')
            expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          end
          within(:css, '#solution_section') do
            expect(page).to have_no_content('FILES')
            expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          end
          within(:css, '#results_section') do
            expect(page).to have_no_content('FILES')
            expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          end
        end
      end

      context 'with saved resources' do
        before do
          visit practice_overview_path(@pr_with_resources)
        end

        it 'should not display the file resource form' do
          expect(page).to have_no_content("Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.")
          expect(page).to have_no_css('#problem_resources_file_form')
          expect(page).to have_no_css('#solution_resources_file_form')
          expect(page).to have_no_css('#results_resources_file_form')
        end

        it 'should display the saved file resources' do
          within(:css, '#problem_section') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('dummy.pdf')
            expect(find_field('File name').value).to eq('file one')
            expect(find_field('File description').value).to eq('problem file description')
            expect(page).to have_content('Delete entry')
          end
          within(:css, '#solution_section') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('dummy.pdf')
            expect(find_field('File name').value).to eq('file two')
            expect(find_field('File description').value).to eq('solution file description')
            expect(page).to have_content('Delete entry')
          end
          within(:css, '#results_section') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('dummy.pdf')
            expect(find_field('File name').value).to eq('file three')
            expect(find_field('File description').value).to eq('results file description')
            expect(page).to have_content('Delete entry')
          end
        end
      end
    end

    # add files
    describe 'complete and add file' do
      before do
        visit practice_overview_path(@pr_no_resources)
      end

      context 'problem section' do
        it 'should save file on practice save' do
          within(:css, '#problem_section') do
            # select file form
            find('label[for=practice_problem_file]').click
            expect(page).to have_content("Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.")
            expect(page).to have_content('File name')
            expect(page).to have_content('File description')
            expect(page).to have_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")

            # upload file
            find('#practice_problem_resources-input-single_RANDOM_NUMBER_OR_SOMETHING_file').attach_file(@file_path_2)
            fill_in('File name', with: 'new file')
            fill_in('File description', with: 'new practice problem file')

            # add file
            find('.add-resource').click
          end

          within(:css, '#display_problem_resources_file') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice problem file')
            expect(page).to have_content('Delete entry')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_problem_resources_file') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice problem file')
          end
        end
      end

      context 'solution section' do
        it 'should save file on practice save' do
          within(:css, '#solution_section') do
            # select file form
            find('label[for=practice_solution_file]').click
            expect(page).to have_content("Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.")
            expect(page).to have_content('File name')
            expect(page).to have_content('File description')
            expect(page).to have_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")

            # upload file
            find('#practice_solution_resources-input-single_RANDOM_NUMBER_OR_SOMETHING_file').attach_file(@file_path_2)
            fill_in('File name', with: 'new file')
            fill_in('File description', with: 'new practice solution file')

            # add file
            find('.add-resource').click
          end

          within(:css, '#display_solution_resources_file') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice solution file')
            expect(page).to have_content('Delete entry')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_solution_resources_file') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice solution file')
          end
        end
      end

      context 'results section' do
        it 'should save file on practice save' do
          within(:css, '#results_section') do
            # select file form
            find('label[for=practice_results_file]').click
            expect(page).to have_content("Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.")
            expect(page).to have_content('File name')
            expect(page).to have_content('File description')
            expect(page).to have_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")

            # upload file
            find('#practice_results_resources-input-single_RANDOM_NUMBER_OR_SOMETHING_file').attach_file(@file_path_2)
            fill_in('File name', with: 'new file')
            fill_in('File description', with: 'new practice results file')

            # add file
            find('.add-resource').click
          end

          within(:css, '#display_results_resources_file') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice results file')
            expect(page).to have_content('Delete entry')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_results_resources_file') do
            expect(page).to have_content('FILES')
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice results file')
          end
        end
      end
    end

    # edit added files
    describe 'edit newly added files' do
      before do
        visit practice_overview_path(@pr_no_resources)
      end

      context 'problem section' do
        it 'should allow user to edit newly added files' do
          within(:css, '#problem_section') do
            # select file form
            find('label[for=practice_problem_file]').click
            # upload file
            upload_field.attach_file(@file_path_2)
            fill_in('File name', with: 'new file')
            fill_in('File description', with: 'new practice problem file')
            # add file
            find('.add-resource').click
          end

          within(:css, '#display_problem_resources_file') do
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice problem file')
            upload_field.attach_file(@file_path_3)
            name_field.set('edited file')
            description_field.set('edited practice problem file')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_problem_resources_file') do
            expect(page).to have_content('charmander.png')
            expect(name_field.value).to eq('edited file')
            expect(description_field.value).to eq('edited practice problem file')
          end
        end
      end

      context 'solution section' do
        it 'should allow user to edit newly added files' do
          within(:css, '#solution_section') do
            # select file form
            find('label[for=practice_solution_file]').click
            # upload file
            upload_field.attach_file(@file_path_2)
            fill_in('File name', with: 'new file')
            fill_in('File description', with: 'new practice solution file')
            # add file
            find('.add-resource').click
          end

          within(:css, '#display_solution_resources_file') do
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice solution file')
            upload_field.attach_file(@file_path_3)
            name_field.set('edited file')
            description_field.set('edited practice solution file')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_solution_resources_file') do
            expect(page).to have_content('charmander.png')
            expect(name_field.value).to eq('edited file')
            expect(description_field.value).to eq('edited practice solution file')
          end
        end
      end

      context 'results section' do
        it 'should allow user to edit newly added files' do
          within(:css, '#results_section') do
            # select file form
            find('label[for=practice_results_file]').click
            # upload file
            upload_field.attach_file(@file_path_2)
            fill_in('File name', with: 'new file')
            fill_in('File description', with: 'new practice results file')
            # add file
            find('.add-resource').click
          end

          within(:css, '#display_results_resources_file') do
            expect(page).to have_content('SpongeBob.txt')
            expect(name_field.value).to eq('new file')
            expect(description_field.value).to eq('new practice results file')
            upload_field.attach_file(@file_path_3)
            name_field.set('edited file')
            description_field.set('edited practice results file')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_results_resources_file') do
            expect(page).to have_content('charmander.png')
            expect(name_field.value).to eq('edited file')
            expect(description_field.value).to eq('edited practice results file')
          end
        end
      end
    end

    # edit existing files
    describe 'edit existing files' do
      before do
        visit practice_overview_path(@pr_with_resources)
      end

      context 'problem section' do
        it 'should allow user to edit existing files' do
          within(:css, '#display_problem_resources_file') do
            expect(page).to have_content('dummy.pdf')
            expect(name_field.value).to eq('file one')
            expect(description_field.value).to eq('problem file description')

            # edit file resource
            name_field.set('edited file')
            description_field.set('edited practice problem file')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_problem_resources_file') do
            expect(name_field.value).to eq('edited file')
            expect(description_field.value).to eq('edited practice problem file')
          end
        end
      end

      context 'solution section' do
        it 'should allow user to edit existing files' do
          within(:css, '#display_solution_resources_file') do
            expect(page).to have_content('dummy.pdf')
            expect(name_field.value).to eq('file two')
            expect(description_field.value).to eq('solution file description')

            # edit file resource
            name_field.set('edited file')
            description_field.set('edited practice solution file')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_solution_resources_file') do
            expect(name_field.value).to eq('edited file')
            expect(description_field.value).to eq('edited practice solution file')
          end
        end
      end

      context 'results section' do
        it 'should allow user to edit existing files' do
          within(:css, '#display_results_resources_file') do
            expect(page).to have_content('dummy.pdf')
            expect(name_field.value).to eq('file three')
            expect(description_field.value).to eq('results file description')

            # edit file resource
            name_field.set('edited file')
            description_field.set('edited practice results file')
          end

          # save practice
          find('#practice-editor-save-button').click
          within(:css, '#display_results_resources_file') do
            expect(name_field.value).to eq('edited file')
            expect(description_field.value).to eq('edited practice results file')
          end
        end
      end
    end
    # error - not filling out form fields
    # error - successfully adding clears errors
    # canceling form - should clear it and errors
  end
end

def upload_field
  find_all('input[type="file"]').first
end

def name_field
  find_all('input[type="text"][class="usa-input"]').first
end

def description_field
  find_all('input[type="text"][class="usa-input"]').last
end
