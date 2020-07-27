require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Impact Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_impact_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
            @image_path = File.join(Rails.root, '/spec/assets/charmander.png')
            @photo_caption = 'This is the cutest charmander image ever'
            @video_file = 'www.youtube.com/awesome-and-random-video'
            @video_caption = 'This is the most awesome video ever'
        end

        it 'should be there' do
            expect(page).to have_content('Impact')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/origin")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/documentation")
        end
        
        def fill_in_impact_photo_fields
            attach_file('Upload photo', @image_path)
            all('.practice-editor-image-caption').first.set(@photo_caption)
        end

        describe 'Impact photos' do
            # it 'should require the user to fill out the fields that are marked as required' do
            #     @save_button.click
            #     upload_photo_message = page.find('.hidden-upload').native.attribute('validationMessage')
            #     expect(upload_photo_message).to eq('Please select a file.')
            #     attach_file('Upload photo', @image_path)
            #     @save_button.click
            #     caption_message = page.find('.practice-editor-image-caption').native.attribute('validationMessage')
            #     expect(caption_message).to eq('Please fill out this field.')
            # end

            it 'should allow the user to add an impact photo and set it as the practice\'s main display image' do
                fill_in_impact_photo_fields
                @save_button.click
                expect(page).to have_content('Practice was successfully updated')
                expect(page).to have_field('practice[impact_photos_attributes][0][description]', with: @photo_caption)
                expect(page).to have_selector('.practice-editor-impact-photo')
            end

            it 'should allow the user to add multiple impact photos' do
                fill_in_impact_photo_fields
                find('.add-impact-photo-link').click
                all('.hidden-upload').last.attach_file(@image_path)
                all('.practice-editor-image-caption').last.set('This is the second cutest charmander image ever')
                @save_button.click

                expect(page).to have_content('Practice was successfully updated')
                expect(page).to have_selector('.practice-editor-impact-photo', count: 2)
                expect(page).to have_field('practice[impact_photos_attributes][0][description]', with: @photo_caption)
                expect(page).to have_field('practice[impact_photos_attributes][1][description]', with: 'This is the second cutest charmander image ever')
            end

            it 'should allow the user to delete impact photos' do
                fill_in_impact_photo_fields
                all('.impact-trash').first.click
                @save_button.click
                expect(page).to_not have_selector('.practice-editor-impact-photo')
                expect(all('.practice-editor-image-caption').first.text).to be_blank
            end

            it 'should allow the user to update a current impact photo\'s text' do
                fill_in_impact_photo_fields
                @save_button.click

                all('.practice-editor-image-caption').first.set('test caption')
                @save_button.click

                expect(page).to have_field('practice[impact_photos_attributes][0][description]', with: 'test caption')
            end
        end

        describe 'Video files' do
            before do
                fill_in_impact_photo_fields
            end

            def fill_in_video_file_fields
                all('.video-file-url-input').first.set(@video_file)
                all('.practice-editor-video-caption').first.set(@video_caption)
            end

            # it 'should require the user to fill out both fields if at least one field is filled out' do
            #     all('.video-file-url-input').first.set(@video_file)
            #     @save_button.click
            #     caption_message = page.find('.practice-editor-video-caption').native.attribute('validationMessage')
            #     expect(caption_message).to eq('Please fill out this field.')
            #     all('.video-file-url-input').first.set(nil)
            #     all('.practice-editor-video-caption').first.set(@video_caption)
            #     link_message = page.find('.video-file-url-input').native.attribute('validationMessage')
            #     expect(caption_message).to eq('Please fill out this field.')
            # end

            it 'should allow the user to add a video file' do
                fill_in_video_file_fields
                @save_button.click
                expect(page).to have_content('Practice was successfully updated')
                expect(page).to have_selector('iframe')
                expect(page).to have_field('practice[video_files_attributes][0][url]', with: @video_file)
                expect(page).to have_field('practice[video_files_attributes][0][description]', with: @video_caption)
            end

            it 'should allow the user to add multiple video files' do
                fill_in_video_file_fields
                find('.add-video-file-link').click

                all('.video-file-url-input').last.set('www.youtube.com/awesome-and-random-video-2')
                all('.practice-editor-video-caption').last.set('This is the second most awesome video ever')
                @save_button.click

                expect(page).to have_selector('iframe', count: 2)
                expect(page).to have_content('Practice was successfully updated')
                expect(page).to have_field('practice[video_files_attributes][0][url]', with: @video_file)
                expect(page).to have_field('practice[video_files_attributes][0][description]', with: @video_caption)
                expect(page).to have_field('practice[video_files_attributes][1][url]', with: 'www.youtube.com/awesome-and-random-video-2')
                expect(page).to have_field('practice[video_files_attributes][1][description]', with: 'This is the second most awesome video ever')
            end

            it 'should allow the user to delete video files' do
                fill_in_video_file_fields
                @save_button.click
                all('.impact-trash').last.click
                @save_button.click
                expect(page).to have_content('Practice was successfully updated')
                expect(page).to_not have_selector('iframe')
                expect(page).to have_field('Link:', with: nil)
                expect(all('.practice-editor-video-caption').first.text).to be_blank
            end
        end
    end
end