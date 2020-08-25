require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @pr_no_resources = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31))
    @pr_with_resources = Practice.create!(name: 'A practice with resources', slug: 'practice-with-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31))
    img_path_1 = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    @problem_resource = PracticeProblemResource.create(practice: @pr_with_resources, name: 'problem resource caption', attachment: File.new(img_path_1))
    @problem_resource = PracticeSolutionResource.create(practice: @pr_with_resources, name: 'problem solution caption', attachment: File.new(img_path_1))
    @problem_resource = PracticeResultsResource.create(practice: @pr_with_resources, name: 'problem results caption', attachment: File.new(img_path_1))
    @img_path_2 = "#{Rails.root}/spec/assets/unacceptable_img_size.png"
    @img_path_3 = "#{Rails.root}/spec/assets/charmander.png"
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Overview page' do
    describe 'Default resource section' do
      context 'with no saved resources' do
        before do
          visit practice_overview_path(@pr_no_resources)
        end

        it 'should not display the image resource form' do
          expect(page).to have_no_content("Use a high-quality .jpg, .jpeg, or .png file that is less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_no_css('#problem_resource_image_form')
          expect(page).to have_no_css('#solution_resource_image_form')
          expect(page).to have_no_css('#results_resource_image_form')
          within(:css, '#problem_section') do
            expect(page).to have_no_content('IMAGES')
            expect(page).to have_no_css("img[src*='acceptable_img.jpg']")
          end
          within(:css, '#solution_section') do
            expect(page).to have_no_content('IMAGES')
            expect(page).to have_no_css("img[src*='acceptable_img.jpg']")
          end
          within(:css, '#results_section') do
            expect(page).to have_no_content('IMAGES')
            expect(page).to have_no_css("img[src*='acceptable_img.jpg']")
          end
        end
      end

      context 'with saved resources' do
        before do
          visit practice_overview_path(@pr_with_resources)
        end

        it 'should not display the image resource form' do
          expect(page).to have_no_content("Use a high-quality .jpg, .jpeg, or .png file that is less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_no_css('#problem_resource_image_form')
          expect(page).to have_no_css('#solution_resource_image_form')
          expect(page).to have_no_css('#results_resource_image_form')
          within(:css, '#problem_section') do
            expect(page).to have_content('IMAGES')
            expect(page).to have_css("img[src*='acceptable_img.jpg']")
          end
          within(:css, '#solution_section') do
            expect(page).to have_content('IMAGES')
            expect(page).to have_css("img[src*='acceptable_img.jpg']")
          end
          within(:css, '#results_section') do
            expect(page).to have_content('IMAGES')
            expect(page).to have_css("img[src*='acceptable_img.jpg']")
          end
        end
      end
    end

    describe 'Problem Resource section' do
      describe 'with no saved images' do
        before do
          visit practice_overview_path(@pr_no_resources)
        end
        context 'clicking cancel' do
          it 'should hide the form' do
            within(:css, '#problem_section') do
              find('label[for=practice_problem_image]').click
              expect(page).to have_content('Drag file here or choose from folder')
              expect(page).to have_no_content('IMAGES')
              expect(page).to have_no_css("img")
              expect(page).to have_content('Caption')
              find('.dm-cropper-upload-image').attach_file(@img_path_3)
              expect(page).to have_css("img")
              expect(page).to have_no_content('Drag file here or choose from folder')
              find('#cancel_problem_resource_image').click
              expect(page).to have_no_css("img")
              expect(page).to have_no_content('Drag file here or choose from folder')
            end
          end
        end
  
        context 'add image with too large file size' do
          it 'should throw an error and clear upload' do
            within(:css, '#problem_section') do
              find('label[for=practice_problem_image]').click
              expect(page).to have_content('Drag file here or choose from folder')
              expect(page).to have_no_content('IMAGES')
              expect(page).to have_no_css("img")
              find('.dm-cropper-upload-image').attach_file(@img_path_2)
              expect(page).to have_content('Sorry, you cannot upload an image larger than 32MB.')
              expect(page).to have_no_css("img")
              expect(page).to have_content('Drag file here or choose from folder')
              expect(page).to have_no_content('Remove image')
              expect(page).to have_no_content('Edit image')
            end
          end
        end
  
        context 'remove uploaded image' do
          it 'should clear upload' do
            within(:css, '#problem_section') do
              find('label[for=practice_problem_image]').click
              expect(page).to have_content('Drag file here or choose from folder')
              expect(page).to have_no_content('IMAGES')
              expect(page).to have_no_css("img")
              find('.dm-cropper-upload-image').attach_file(@img_path_3)
              expect(page).to have_css("img")
              expect(page).to have_no_content('Drag file here or choose from folder')
              expect(page).to have_content('Remove image')
              expect(page).to have_content('Edit image')
              find('.dm-cropper-delete-image').click
              expect(page).to have_no_css("img")
              expect(page).to have_content('Drag file here or choose from folder')
              expect(page).to have_no_content('Remove image')
              expect(page).to have_no_content('Edit image')
            end
          end
        end
  
        context 'not including a caption' do
          it 'should throw an error and prevent adding image' do
            within(:css, '#problem_section') do
              find('label[for=practice_problem_image]').click
              expect(page).to have_content('Drag file here or choose from folder')
              expect(page).to have_no_content('IMAGES')
              expect(page).to have_no_css("img")
              expect(page).to have_content('Caption')
              find('.dm-cropper-upload-image').attach_file(@img_path_3)
              expect(page).to have_css("img")
              expect(page).to have_no_content('Drag file here or choose from folder')
              expect(page).to have_content('Remove image')
              expect(page).to have_content('Edit image')
              find('.add-resource').click
              expect(page).to have_content('Please enter a caption.')
            end
  
            within(:css, '#display_problem_resources_image') do
              expect(page).to have_no_css("img")
            end
          end
        end
  
        context 'uploading and cropping and image' do
          it 'should add the image on save' do
            within(:css, '#problem_section') do
              find('label[for=practice_problem_image]').click
              expect(page).to have_content('Drag file here or choose from folder')
              expect(page).to have_no_content('IMAGES')
              expect(page).to have_no_css("img")
              expect(page).to have_content('Caption')
              find('.dm-cropper-upload-image').attach_file(@img_path_3)
              expect(page).to have_css("img")
              expect(page).to have_no_content('Drag file here or choose from folder')
              expect(page).to have_content('Remove image')
              expect(page).to have_content('Edit image')
              find('.add-resource').click
              expect(page).to have_content('Please enter a caption.')
            end
  
            within(:css, '#display_problem_resources_image') do
              expect(page).to have_no_css("img")
            end
          end
        end
      end

    end


      # def first_metric_field
      #   find_all('.practice-editor-metric-li').first
      # end

      # def first_metric_field_input
      #   first_metric_field.find('input')
      # end

      # def last_metric_field
      #   find_all('.practice-editor-metric-li').last
      # end

      # def last_metric_field_input
      #   last_metric_field.find('input')
      # end
  end
end

def upload_new_img(img_path)
  attach_file(find('.dm-cropper-upload-image'), img_path)
end
