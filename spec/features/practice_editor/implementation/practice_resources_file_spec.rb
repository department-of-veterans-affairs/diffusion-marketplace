require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A practice with no resources', slug: 'test-practice', approved: true, published: true, date_initiated: Date.new(2011, 12, 31))
    PracticeResource.create(practice: @practice, resource: 'core person 1', resource_type: 'core', media_type: 'resource', resource_type_label: 'people', position: 1 )
    @file_path_1 = "#{Rails.root}/spec/assets/dummy.pdf"
    @file_path_2 = "#{Rails.root}/spec/assets/SpongeBob.txt"
    @file_path_3 = "#{Rails.root}/spec/assets/charmander.png"
    @file_path_size_error = "#{Rails.root}/spec/assets/unacceptable_img_size.png"
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Implementation page -- resource link:' do
    describe 'complete form, edit, and remove files' do
      def complete_add_file_test(area)
        # add files
        visit practice_implementation_path(@practice)

        within(:css, ".dm-#{area}-attachment-form") do
          expect(page).to have_no_content('Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.')
          expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          expect(page).to have_no_content('Drag file here or choose from folder')
          expect(page).to have_no_content('File name')
          expect(page).to have_no_content('File description')
          click_file_form area
          expect(page).to have_content('Upload a .pdf, .docx, .xlxs, .jpg, .jpeg, or .png file that is less than 32MB.')
          expect(page).to have_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          expect(page).to have_content('Drag file here or choose from folder')
          expect(page).to have_content('File name')
          expect(page).to have_content('File description')
          add_resource
          # check that errors appear
          expect(page).to have_content('Please upload a file')

          upload_file(area, 0, @file_path_size_error)
          expect(page).to have_no_content('Please upload a file')
          expect(page).to have_content('Sorry, you cannot upload a file larger than 32MB.')
          expect(page).to have_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          expect(page).to have_content('Drag file here or choose from folder')
          upload_file(area, 0, @file_path_1)
          expect(page).to have_no_content('Sorry, you cannot upload a file larger than 32MB.')
          expect(page).to have_no_content('Drag file here or choose from folder')
          add_resource
          expect(page).to have_content('Please enter a file name')
          first_name_field.set("first new #{area} file")
          add_resource
          expect(page).to have_content('Please enter a file description')
          first_description_field.set("first new practice #{area} file")
          add_resource
          # check that errors are gone
          expect(find_all('.overview_error_msg').length).to eq 0
          # check that form cleared
          expect(first_name_field.value).to eq ''
          expect(first_description_field.value).to eq ''
          cancel_form area
          expect(page).to have_no_css("##{area}_resources_file_form")
          # add another file
          click_file_form area
          upload_file(area, 0, @file_path_2)
          first_name_field.set("second new #{area} file")
          first_description_field.set("second new practice #{area} file")
          add_resource
        end

        within(:css, "#display_#{area}_attachment_file") do
          expect(page).to have_content('Delete entry')
          expect(page).to have_content('File: dummy.pdf')
          expect(page).to have_no_css("input[accept='.pdf,.docx,.xlxs,.jpg,.jpeg,.png']")
          expect(first_name_field.value).to eq "first new #{area} file"
          expect(first_description_field.value).to eq "first new practice #{area} file"
          expect(page).to have_content('SpongeBob.txt')
          expect(second_name_field.value).to eq "second new #{area} file"
          expect(second_description_field.value).to eq "second new practice #{area} file"
        end

        save_practice

        # check files appear in view
        visit practice_path(@practice)
        within(:css, '#dm-implementation-show-resources') do
          expect(page).to have_content("first new #{area} file")
          expect(page).to have_content("second new #{area} file")
          expect(page).to have_content("first new practice #{area} file")
          expect(page).to have_content("second new practice #{area} file")
          expect(page).to have_css(".dm-external-link")
        end

        # edit practice
        visit practice_implementation_path(@practice)
        within(:css, "#display_#{area}_attachment_file") do
          first_name_field.set("first edited #{area} file")
          first_description_field.set("first edited practice #{area} file")
        end
        save_practice

        # check edited file appears in view
        visit practice_path(@practice)
        within(:css, '#dm-implementation-show-resources') do
          expect(page).to have_content("first edited #{area} file")
          expect(page).to have_content("second new #{area} file")
          expect(page).to have_content("first edited practice #{area} file")
          expect(page).to have_content("second new practice #{area} file")
          expect(page).to have_css(".dm-external-link")
          expect(page).to have_no_content("first new #{area} file")
          expect(page).to have_no_content("first new practice #{area} file")
        end

        # delete link
        visit practice_implementation_path(@practice)
        within(:css, "#display_#{area}_attachment_file") do
          delete_entry(0)
        end
        save_practice

        # check the links do not show up on view
        visit practice_path(@practice)
        within(:css, '#dm-implementation-show-resources') do
          expect(page).to have_no_content("first edited #{area} file")
          expect(page).to have_content("second new #{area} file")
          expect(page).to have_no_content("first edited practice #{area} file")
          expect(page).to have_content("second new practice #{area} file")
        end
      end

      it 'should save, edit, and delete files' do
        complete_add_file_test 'core'
        complete_add_file_test 'optional'
        complete_add_file_test 'support'
      end

      it 'should render file_attachment_name if name and description are blank' do
        PracticeResource.create(practice: @practice, resource: 'core person 99', resource_type: 'optional', media_type: 'file', position: 2, name: '', description: '', attachment_content_type: 'image/jpeg', attachment_file_name: 'file.jpg' )
        visit practice_path(@practice)
        expect(page).to have_content("file.jpg")
        PracticeResource.delete(2)
      end
    end
  end

  def upload_file(area, index, file)
    find_all('input[type="file"]')[index].attach_file(file)
  end

  def first_name_field
    find_all('input[type="text"]')[0]
  end

  def first_description_field
    find_all('input[type="text"]')[1]
  end

  def second_name_field
    find_all('input[type="text"]')[2]
  end

  def second_description_field
    find_all('input[type="text"]')[3]
  end

  def delete_entry(index)
    find_all('.remove_nested_fields')[index].click
  end

  def click_file_form(area)
    find("label[for=#{area}_resource_attachment_file]").click
  end

  def add_resource
    find('.add-resource').click
  end

  def cancel_form(area)
    find("#cancel_#{area}_attachment_file").click
  end

  def save_practice
    find('#practice-editor-save-button').click
  end
end
