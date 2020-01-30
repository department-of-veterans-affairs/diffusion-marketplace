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
        end

        it 'should be there' do
            expect(page).to have_content('Origin')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/origin")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/documentation")
        end

        describe 'Impact photos' do
            it 'should require the user to fill out the fields that are marked as required' do
                save_button = find('#practice-editor-save-button')
                save_button.click
                upload_photo_message = page.find('.hidden-upload').native.attribute('validationMessage')
                expect(upload_photo_message).to eq('Please select a file.')
                image_path = File.join(Rails.root, '/spec/assets/charmander.png')
                attach_file('Upload photo', image_path)
                save_button.click
                caption_message = page.find('.practice-editor-image-caption').native.attribute('validationMessage')
                expect(caption_message).to eq('Please fill out this field.')
            end

            it 'should allow the user to add an impact photo and set it as the practice\'s main display image' do
                save_button = find('#practice-editor-save-button')
                image_path = File.join(Rails.root, '/spec/assets/charmander.png')
                attach_file('Upload photo', image_path)
                find('.usa-radio__label').click
                all('.practice-editor-image-caption').first.set('This is the cutest charmander image ever')
                save_button.click
                expect(page).to have_content('Practice was successfully updated')
                expect(page).to have_field('practice[impact_photos_attributes][0][description]', with: 'This is the cutest charmander image ever')
                expect(page).to have_selector('.practice-editor-impact-photo ')
                expect(find_field('practice[impact_photos_attributes][0][is_main_display_image]')).to be_checked
            end

            it 'should allow the user to add multiple impact photos' do

            end
        end
    end
end