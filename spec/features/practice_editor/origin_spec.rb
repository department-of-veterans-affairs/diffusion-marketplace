require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Origin page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_origin_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
            @image_path = File.join(Rails.root, '/spec/assets/charmander.png')
            @origin_story = 'This practice was founded on the basis of being awesome'
            @creator_name = 'Grimmjow Jaegerjaquez'
            @creator_role = 'Sixth Espada'
            @choose_image_text = 'Choose an image that clearly shows a face. Use a high-quality .jpg, .jpeg, or .png files less than 32MB.'
        end

        it 'should be there' do
            expect(page).to have_content('Origin')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/overview")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/impact")
            expect(page).to have_content('Upload photo')
            expect(page).to have_content('Choose an image that clearly shows a face. Use a high-quality .jpg, .jpeg, or .png files less than 32MB.')
            expect(page).to have_no_content('Remove photo')
            expect(page).to have_no_content('Edit photo')
            expect(page).to have_no_content('Upload new photo')
            expect(page).to have_no_content('Cancel edits')
            expect(page).to have_no_content('Save edits')
        end

        # it 'should require the user to fill out the fields that are marked as required' do
        #     @save_button.click
        #     origin_story_message = page.find('.origin-story-textarea').native.attribute('validationMessage')
        #     expect(origin_story_message).to eq('Please fill out this field.')
        #     fill_in('practice_origin_story', with: @origin_story)
        #     @save_button.click
        #     practice_creator_name_message = page.find('.practice-creator-name-input').native.attribute('validationMessage')
        #     expect(practice_creator_name_message).to eq('Please fill out this field.')
        #     fill_in('Name', with: @creator_name)
        #     @save_button.click
        #     practice_creator_role_message = page.find('.practice-creator-role').native.attribute('validationMessage')
        #     expect(practice_creator_role_message).to eq('Please fill out this field.')
        # end

        def fill_in_origin_story_field
            fill_in('Origin story', with: @origin_story)
        end

        def fill_in_creator_fields
            fill_in('Name', with: @creator_name)
            fill_in('Role', with: @creator_role)
            attach_file('Upload photo', @image_path)
        end

        it 'should allow the user to add a practice creator' do
            fill_in_origin_story_field
            fill_in_creator_fields
            @save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Origin story:', with: @origin_story)
            expect(page).to have_field('Name:', with: @creator_name)
            expect(page).to have_field('Role:', with: @creator_role)
            expect(page).to have_content('Upload new photo')
            expect(page).to have_content('Remove photo')
            expect(page).to have_content('Edit photo')
            expect(page).to have_content(@choose_image_text)
            expect(page).to have_no_content('Upload photo')
            expect(page).to have_no_content('Cancel edits')
            expect(page).to have_no_content('Save edits')
        end

        it 'should allow the user to add multiple practice creators' do
            fill_in_origin_story_field
            fill_in_creator_fields
            @save_button.click

            find('.add-practice-creator-link').click
            all('.practice-creator-name-input').last.set('Renji Abarai')
            all('.practice-creator-role').last.set('Lieutenant of squad six')
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Origin story:', with: @origin_story)
            expect(page).to have_field('practice[practice_creators_attributes][0][name]', with: @creator_name)
            expect(page).to have_field('practice[practice_creators_attributes][0][role]', with: @creator_role)
            expect(page).to have_field('practice[practice_creators_attributes][1][name]', with: 'Renji Abarai')
            expect(page).to have_field('practice[practice_creators_attributes][1][role]', with: 'Lieutenant of squad six')
            expect(page).to have_content('Upload new photo')
            expect(page).to have_content('Remove photo')
            expect(page).to have_content(@choose_image_text)
            expect(page).to have_content('Edit photo')
            expect(page).to have_content('Upload photo')
            expect(page).to have_no_content('Cancel edits')
            expect(page).to have_no_content('Save edits')
        end

        it 'should allow the user to delete practice creators' do
            fill_in_origin_story_field
            fill_in_creator_fields
            @save_button.click

            find('.dm-origin-trash').click
            @save_button.click

            expect(page).to have_field('Name:', with: nil)
            expect(page).to have_field('Role:', with: nil)
        end
    end
end
