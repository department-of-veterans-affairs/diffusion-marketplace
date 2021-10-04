require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @pr_no_resources = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement', user: @admin)
    @pr_with_resources = Practice.create!(name: 'A practice with resources', slug: 'practice-with-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement', user: @admin)
    @img_path_1 = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    @img_path_2 = "#{Rails.root}/spec/assets/charmander.png"
    @img_path_3 = "#{Rails.root}/spec/assets/SpongeBob.png"
    @img_path_err = "#{Rails.root}/spec/assets/unacceptable_img_size.png"
    PracticeProblemResource.create(practice: @pr_with_resources, name: 'existing problem image', attachment: File.new(@img_path_1), resource_type: 0)
    PracticeSolutionResource.create(practice: @pr_with_resources, name: 'existing solution image', attachment: File.new(@img_path_1), resource_type: 0)
    PracticeResultsResource.create(practice: @pr_with_resources, name: 'existing results image',  attachment: File.new(@img_path_1), resource_type: 0)
    PracticeMultimedium.create(practice: @pr_with_resources, name: 'existing multimedia image',  attachment: File.new(@img_path_1), resource_type: 0)
    @frame_index = { problem: 0, solution: 1, results: 2, multimedia: 3 }
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Overview page -- resource & multimedia image:' do
    describe 'default view' do
      context 'with no saved images' do
        before do
          no_resource_pr_test_setup
        end

        it 'should not display the image resource form' do
          expect(page).to have_no_content('Caption')
          expect(page).to have_no_css('#problem_resources_image_form')
          expect(page).to have_no_css('#solution_resources_image_form')
          expect(page).to have_no_css('#results_resources_image_form')
          expect(page).to have_no_css('#multimedia_image_form')
        end
      end

      context 'with saved resources' do
        before do
          with_resource_pr_test_setup
        end

        def saved_image_display_test(area)
          within(:css, "##{area}_section") do
            expect(page).to have_content('IMAGES')
            expect(page).to have_css("img[src*='acceptable_img.jpg']")
            expect(caption_field.value).to eq("existing #{area} image")
            expect(page).to have_content('Delete entry')
          end
        end

        it 'should display the saved image' do
          saved_image_display_test 'problem'
          saved_image_display_test 'solution'
          saved_image_display_test 'results'
          saved_image_display_test 'multimedia'
        end
      end
    end

    describe 'complete form, crop and add image' do
      before do
        no_resource_pr_test_setup
      end

      def cancel_form(area)
        area_name = area == 'multimedia' ? area : "#{area}_resources"
        find("#cancel_#{area_name}_image").click
      end

      def is_clear_form
        expect(page).to have_content("Use a high-quality .jpg, .jpeg, or .png file that is less than 32MB.")
        expect(page).to have_css("input[accept='.jpg,.jpeg,.png']")
        expect(page).to have_no_css("img")
        expect(page).to have_content('Drag file here or choose from folder')
        expect(page).to have_no_content('Remove image')
        expect(page).to have_no_content('Edit image')
        expect(page).to have_content('Caption')
        expect(caption_field.value).to eq ''
      end

      def complete_add_image_test(area)
        area_name = set_area_name area
        click_image_form area
        within(:css, "##{area_name}_image_form") do
          is_clear_form
          add_resource
          expect(page).to have_content('Please upload an image')
          upload_image @img_path_err
          is_clear_form
          expect(page).to have_content('Sorry, you cannot upload an image larger than 32MB.')
          upload_image @img_path_2
          expect(page).to have_css('img')
          expect(page).to have_no_content('Drag file here or choose from folder')
          expect(page).to have_content('Remove image')
          expect(page).to have_content('Edit image')
          find('.dm-cropper-edit-mode').click
          expect(page).to have_css('.dm-cropper-cancel-edit')
          expect(page).to have_css('.dm-cropper-save-edit')
          expect(page).to have_css('.cropper-container')
          find('.dm-cropper-save-edit').click
          check_crop_values 2
          find('.dm-cropper-delete-image').click
          check_crop_values 0
          is_clear_form
          upload_image @img_path_2
          crop_image
          check_crop_values 2
          add_resource
          expect(page).to have_content('Please enter a caption')
          caption_field.set("new practice #{area} image")
          add_resource
          expect(find_all('.overview_error_msg').length).to eq 0
          is_clear_form
          cancel_form area
        end
        expect(page).to have_no_css("##{area_name}_image_form")


        within(:css, "#display_#{area_name}_image") do
          check_crop_values 2
          expect(page).to have_content('IMAGES')
          expect(caption_field.value).to eq("new practice #{area} image")
          expect(page).to have_content('Delete entry')
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_content("Images")
        expect(page).to have_css("img[src*='charmander.png']")
        expect(page).to have_content("new practice #{area} image")
      end

      it 'problem section - should save image' do
        complete_add_image_test 'problem'
      end

      it 'solution section - should save image' do
        complete_add_image_test 'solution'
      end

      it 'results section - should save image' do
        complete_add_image_test 'results'
      end

      it 'multimedia section - should save image' do
        complete_add_image_test 'multimedia'
      end
    end

    describe 'edit newly added image' do
      before do
        no_resource_pr_test_setup
      end

      def edit_added_image_test(area)
        area_name = set_area_name area
        within(:css, "##{area}_section") do
          click_image_form area
          upload_image @img_path_2
          caption_field.set("new practice #{area} image")
          add_resource
        end

        within(:css, "#display_#{area_name}_image") do
          expect(page).to have_css('img')
          expect(caption_field.value).to eq("new practice #{area} image")
          check_crop_values 0
          crop_image
          check_crop_values 2
          caption_field.set("edited practice #{area} image")
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_content("Images")
        expect(page).to have_content("edited practice #{area} image")
        expect(page).to have_css("img[src*='charmander.png']")
      end

      it 'problem section - should allow user to edit newly added image' do
        edit_added_image_test 'problem'
      end

      it 'solution section - should allow user to edit newly added image' do
        edit_added_image_test 'solution'
      end

      it 'results section - should allow user to edit newly added image' do
        edit_added_image_test 'results'
      end

      it 'multimedia section - should allow user to edit newly added image' do
        edit_added_image_test 'multimedia'
      end
    end

    describe 'edit existing image' do
      before do
        with_resource_pr_test_setup
      end

      def edit_existing_image_test(area)
        area_name = set_area_name area
        within(:css, "#display_#{area_name}_image") do
          caption_field.set("edited practice #{area} image")
          check_crop_values 0
          crop_image
          check_crop_values 1
        end

        save_practice
        visit practice_path(@pr_with_resources)
        expect(page).to have_css("img[src*='acceptable_img.jpg']")
        expect(page).to have_content("edited practice #{area} image")
      end

      it 'problem section - should allow user to edit existing image' do
        edit_existing_image_test 'problem'
      end

      it 'solution section - should allow user to edit existing image' do
        edit_existing_image_test 'solution'
      end

      it 'results section - should allow user to edit existing image' do
        edit_existing_image_test 'results'
      end

      it 'multimedia section - should allow user to edit existing image' do
        edit_existing_image_test 'multimedia'
      end
    end

    describe 'delete new and existing images' do
      before do
        with_resource_pr_test_setup
      end

      def delete_entries_test(area)
        area_name = set_area_name area
        within(:css, "#display_#{area_name}_image") do
          click_button('Delete entry')
          expect(page).to have_no_content("existing #{area} image")
        end

        within(:css, "##{area}_section") do
          click_image_form area
          upload_image @img_path_3
          caption_field.set("new practice #{area} image")
          add_resource
        end

        within(:css, "#display_#{area_name}_image") do
          expect(caption_field.value).to eq("new practice #{area} image")
          click_button('Delete entry')
        end

        save_practice
      end

      it 'should allow user to delete existing image' do
        delete_entries_test 'problem'
        delete_entries_test 'solution'
        delete_entries_test 'results'
        delete_entries_test 'multimedia'
        visit practice_overview_path(@pr_with_resources)
        expect(page).to have_no_content("existing problem image")
        expect(page).to have_no_content("existing solution image")
        expect(page).to have_no_content("existing results image")
        expect(page).to have_no_content("existing multimedia image")
        expect(page).to have_no_content("new practice problem image")
        expect(page).to have_no_content("new practice solution image")
        expect(page).to have_no_content("new practice results image")
        expect(page).to have_no_content("new practice multimedia image")
        expect(page).to have_no_css("img[src*='acceptable_img.jpg']")
        expect(page).to have_no_css("img[src*='charmander.png']")
      end
    end
  end

  def set_area_name(area)
    area == 'multimedia' ? area : "#{area}_resources"
  end

  def upload_image(img_path)
    find('.dm-cropper-upload-image').attach_file(img_path)
  end

  def caption_field
    find_all('input[type="text"]').first
  end

  def crop_image
    find('.dm-cropper-edit-mode').click
    find('.dm-cropper-save-edit').click
  end

  def click_image_form(area)
    find("label[for=practice_#{area}_image]").click
  end

  def add_resource
    find('.add-resource').click
  end

  def save_practice
    find('#practice-editor-save-button').click
  end

  def check_crop_values(img_num)
    if (img_num == 0)
      expect(find(".crop_x", :visible => false).value).to eq ''
      expect(find(".crop_y", :visible => false).value).to eq ''
      expect(find(".crop_w", :visible => false).value).to eq ''
      expect(find(".crop_h", :visible => false).value).to eq ''
    elsif (img_num == 1)
      expect(find(".crop_x", :visible => false).value).to eq '79'
      expect(find(".crop_y", :visible => false).value).to eq '53'
      expect(find(".crop_w", :visible => false).value).to eq '634'
      expect(find(".crop_h", :visible => false).value).to eq '422'
    elsif (img_num == 2 )
      expect(find(".crop_x", :visible => false).value).to eq '22'
      expect(find(".crop_y", :visible => false).value).to eq '22'
      expect(find(".crop_w", :visible => false).value).to eq '180'
      expect(find(".crop_h", :visible => false).value).to eq '180'
    end
  end

  def no_resource_pr_test_setup
    visit practice_path(@pr_no_resources)
    expect(page).to have_content('Overview')
    expect(page).to have_no_content("Images")
    within(:css, '#overview') do
      expect(page).to have_no_css("img")
    end
    visit practice_overview_path(@pr_no_resources)
  end

  def with_resource_pr_test_setup
    visit practice_path(@pr_with_resources)
    expect(page).to have_content('Overview')
    expect(page).to have_content("Images")
    expect(page).to have_css("img[src*='acceptable_img.jpg']")
    expect(page).to have_content("existing problem image")
    expect(page).to have_content("existing solution image")
    expect(page).to have_content("existing problem image")
    visit practice_overview_path(@pr_with_resources)
  end
end
