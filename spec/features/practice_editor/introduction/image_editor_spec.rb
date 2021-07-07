require 'rails_helper'

describe 'Diffusion Marketplace image editor', type: :feature, js: true do
  before do
    admin = User.create!(email: 'admin-dmva@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    admin.add_role(User::USER_ROLES[0].to_sym)

    @acceptable_img_path = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    @unacceptable_img_dimension_path = "#{Rails.root}/spec/assets/unacceptable_img_dimension.jpg"
    @unacceptable_img_size_path = "#{Rails.root}/spec/assets/unacceptable_img_size.png"

    @pr_with_thumbnail = Practice.create!(name: 'A practice with a thumbnail', tagline: 'A public tagline',  slug: 'a-thumbnail-practice', summary: 'test summary', date_initiated: Time.now, initiating_facility: 'test facility', initiating_facility_type: 'other', approved: true, published: true, main_display_image: File.new(@acceptable_img_path), user: admin)
    @pr_without_thumbnail = Practice.create!(name: 'A practice without a thumbnail', tagline: 'A public tagline', slug: 'a-no-thumbnail-practice', summary: 'test summary', date_initiated: Time.now, initiating_facility: 'test facility', initiating_facility_type: 'other', approved: true, published: true, user: admin)

    login_as(admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Section content on load' do
    context 'for a practice without a thumbnail' do
      before do
        visit practice_introduction_path(@pr_without_thumbnail)
      end

      it 'should not display an image' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Drag file here or choose from folder')
          expect(page).to have_content('Thumbnail')
          expect(page).to have_content("Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png file that is at least 768px wide and 432px high and less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_link(href: Constants::FORM_3203_URL)
          expect(page).to have_no_css('.dm-cropper-thumbnail-modified')
          expect(page).to have_no_css('canvas')
          expect(page).to have_no_content('Remove image')
          expect(page).to have_no_content('Edit image')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
        end
      end
    end

    context 'for a practice with a thumbnail' do
      before do
        visit practice_introduction_path(@pr_with_thumbnail)
      end

      it 'should display an image' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Thumbnail')
          expect(page).to have_content("Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png file that is at least 768px wide and 432px high and less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_link(href: Constants::FORM_3203_URL)
          expect(page).to have_css("img[src*='acceptable_img.jpg']")
          expect(page).to have_no_css('canvas')
          expect(page).to have_content('Remove image')
          expect(page).to have_content('Edit image')
          expect(page).to have_no_content('Drag file here or choose from folder')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
        end
      end
    end
  end

  describe 'Uploading an image' do
    context 'that is within the constraints' do
      before do
        visit practice_introduction_path(@pr_without_thumbnail)
        upload_img @acceptable_img_path
        click_save
      end

      it 'should display the image and save it' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Thumbnail')
          expect(page).to have_content("Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png file that is at least 768px wide and 432px high and less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_link(href: Constants::FORM_3203_URL)
          expect(page).to have_css("img[src*='acceptable_img.jpg']")
          expect(page).to have_content('Remove image')
          expect(page).to have_content('Edit image')
          expect(page).to have_no_css('canvas')
          expect(page).to have_no_content('Drag file here or choose from folder')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
        end
      end
    end

    context 'that is over the specified file size' do
      before do
        visit practice_introduction_path(@pr_without_thumbnail)
        expect(page).to have_no_content('Sorry, you cannot upload an image larger than 32MB.')
        upload_img @unacceptable_img_size_path
      end

      it 'should display an alert' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Sorry, you cannot upload an image larger than 32MB.')
          expect(page).to have_content('Drag file here or choose from folder')
          expect(page).to have_no_css("img[src*='unacceptable_img_size.png']")
          expect(page).to have_no_css('canvas')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
          expect(page).to have_no_content('Remove image')
        end
      end
    end

    context 'that is under the specified file dimensions' do
      before do
        visit practice_introduction_path(@pr_with_thumbnail)
        expect(page).to have_no_content('Sorry, you cannot upload an image smaller than 768px wide by 432px high.')
        click_remove_img
        upload_img @unacceptable_img_dimension_path
      end

      it 'should display an alert' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Sorry, you cannot upload an image smaller than 768px wide by 432px high.')
          expect(page).not_to have_css("img[src*='acceptable_img.jpg']")
          expect(page).not_to have_css("img[src*='unacceptable_img_dimension.jpg']")
          expect(page).to have_content('Drag file here or choose from folder')
          expect(page).to have_no_content('Remove image')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
          expect(page).to have_no_content('Remove image')
        end
      end
    end
  end

  describe 'Removing an image' do
    context 'that was already set' do
      before do
        visit practice_introduction_path(@pr_with_thumbnail)
        expect(page).to have_css('.dm-cropper-thumbnail-modified')
        click_remove_img
        click_save
      end

      it 'should remove the image' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Drag file here or choose from folder')
          expect(page).to have_content('Thumbnail')
          expect(page).to have_content("Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png file that is at least 768px wide and 432px high and less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_link(href: Constants::FORM_3203_URL)
          expect(page).to have_no_css("img[src*='acceptable_img.jpg']")
          expect(page).to have_no_css('.dm-cropper-thumbnail-modified')
          expect(page).to have_no_css('canvas')
          expect(page).to have_no_content('Remove image')
          expect(page).to have_no_content('Edit image')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
        end
      end
    end

    context 'that was uploaded' do
      before do
        visit practice_introduction_path(@pr_without_thumbnail)
        upload_img @acceptable_img_path
        find(:css, '.dm-cropper-thumbnail-modified')
        expect(page).to have_css('.dm-cropper-thumbnail-modified')
        click_remove_img
      end

      it 'should remove the image' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Drag file here or choose from folder')
          expect(page).to have_content('Thumbnail')
          expect(page).to have_no_content('Sorry, you cannot upload an image smaller than 768px wide by 432px high.')
          expect(page).to have_content("Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png file that is at least 768px wide and 432px high and less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_link(href: Constants::FORM_3203_URL)
          expect(page).to have_no_css("img[src*='acceptable_img.jpg']")
          expect(page).to have_no_css('canvas')
          expect(page).to have_no_content('Remove image')
          expect(page).to have_no_content('Edit image')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
        end
      end
    end

    context 'in crop mode' do
      before do
        visit practice_introduction_path(@pr_with_thumbnail)
        expect(page).to have_css('.dm-cropper-thumbnail-modified')
        click_edit_img
      end

      it 'should remove the image' do
        within('section.dm-image-editor') do
          expect(page).to have_no_content('Drag file here or choose from folder')
          expect(page).to have_content('Thumbnail')
          expect(page).to have_content("Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png file that is at least 768px wide and 432px high and less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_link(href: Constants::FORM_3203_URL)
          expect(page).to have_css("img[src*='acceptable_img.jpg']")
          expect(page).to have_no_css('canvas')
          expect(page).to have_css('.cropper-container')
          expect(page).to have_content('Remove image')
          expect(page).to have_content('Cancel edits')
          expect(page).to have_content('Save edits')
          expect(page).to have_no_content('Edit image')

          # ensure the crop is reset when image is removed
          expect(find("#crop_x", :visible => false).value).to match ''
          expect(find("#crop_y", :visible => false).value).to match ''
          expect(find("#crop_w", :visible => false).value).to match ''
          expect(find("#crop_h", :visible => false).value).to match ''

          click_save_edits
          expect(find("#crop_x", :visible => false).value).to match '79'
          expect(find("#crop_y", :visible => false).value).to match '85'
          expect(find("#crop_w", :visible => false).value).to match '634'
          expect(find("#crop_h", :visible => false).value).to match '356'
          expect(page).to have_css('canvas')

          click_remove_img
          expect(find("#crop_x", :visible => false).value).to match ''
          expect(find("#crop_y", :visible => false).value).to match ''
          expect(find("#crop_w", :visible => false).value).to match ''
          expect(find("#crop_h", :visible => false).value).to match ''
          expect(page).to have_content('Drag file here or choose from folder')
          expect(page).to have_no_css("img[src*='acceptable_img.jpg']")
          expect(page).to have_no_css('.cropper-container')
          expect(page).to have_no_css('canvas')
          expect(page).to have_no_content('Remove image')
          expect(page).to have_no_content('Cancel edits')
          expect(page).to have_no_content('Save edits')
          expect(page).to have_no_content('Edit image')
        end
      end
    end
  end

  describe 'Cropping an image' do
    context 'that was already set' do
      before do
        visit practice_introduction_path(@pr_with_thumbnail)
        click_edit_img
        expect(page).to have_css('.cropper-container')
      end

      it 'should crop the image' do
        within('section.dm-image-editor') do
          expect(page).to have_content('Thumbnail')
          expect(page).to have_content("Choose an image to represent this practice. Use a high-quality .jpg, .jpeg, or .png file that is at least 768px wide and 432px high and less than 32MB. If you want to upload an image that features a Veteran you must have Form 3203. Waivers must be filled out with the 'External to VA' check box selected.")
          expect(page).to have_link(href: Constants::FORM_3203_URL)
          expect(page).to have_css("img[src*='acceptable_img.jpg']")
          expect(page).to have_content('Cancel edits')
          expect(page).to have_content('Remove image')
          expect(page).to have_content('Save edits')
          expect(page).to have_no_content('Drag file here or choose from folder')
          expect(page).to have_no_content('Edit image')
          expect(find("#crop_x", :visible => false).value).to match ''
          expect(find("#crop_y", :visible => false).value).to match ''
          expect(find("#crop_w", :visible => false).value).to match ''
          expect(find("#crop_h", :visible => false).value).to match ''

          click_save_edits
          expect(page).to have_css('canvas')
          expect(find("#crop_x", :visible => false).value).to match '79'
          expect(find("#crop_y", :visible => false).value).to match '85'
          expect(find("#crop_w", :visible => false).value).to match '634'
          expect(find("#crop_h", :visible => false).value).to match '356'
        end
        click_edit_img
        click_save_edits
        expect(page).to have_css('canvas')
        expect(page).to have_css(".dm-cropper-thumbnail-modified")
      end

      it 'should exit crop mode but retain the cropped image' do
        within('section.dm-image-editor') do
          expect(find("#crop_x", :visible => false).value).to match ''
          expect(find("#crop_y", :visible => false).value).to match ''
          expect(find("#crop_w", :visible => false).value).to match ''
          expect(find("#crop_h", :visible => false).value).to match ''

          click_save_edits
          expect(page).to have_css('canvas')
          expect(find("#crop_x", :visible => false).value).to match '79'
          expect(find("#crop_y", :visible => false).value).to match '85'
          expect(find("#crop_w", :visible => false).value).to match '634'
          expect(find("#crop_h", :visible => false).value).to match '356'

          click_edit_img
          click_cancel_edits
          expect(page).to have_css('canvas')
          expect(find("#crop_x", :visible => false).value).to match '79'
          expect(find("#crop_y", :visible => false).value).to match '85'
          expect(find("#crop_w", :visible => false).value).to match '634'
          expect(find("#crop_h", :visible => false).value).to match '356'
        end
      end
    end
  end
end

def click_save
  find('#practice-editor-save-button').click
end

def click_remove_img
  find('.dm-cropper-delete-image-label').click
end

def click_edit_img
  find('.dm-cropper-edit-mode').click
end

def click_save_edits
  find('.dm-cropper-save-edit').click
end

def click_cancel_edits
  find('.dm-cropper-save-edit').click
end

def upload_img(img_path)
  find('.dm-cropper-upload-image').attach_file(img_path)
end
