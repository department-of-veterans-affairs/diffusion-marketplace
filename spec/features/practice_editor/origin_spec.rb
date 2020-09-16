require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'An awesome practice', slug: 'an-awesome-practice', approved: true, published: true, tagline: 'Test tagline', date_initiated: Date.new(2011, 12, 31))
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'About page' do
        before do
            @practice
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_about_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @origin_story = 'This practice was founded on the basis of being awesome.'
            @creator_name = 'Grimmjow Jaegerjaquez'
            @creator_role = 'Sixth Espada'
            @creator_name_2 = 'Sosuke Aizen'
            @creator_role_2 = 'Leader of the Espada'
        end

        it 'should be there' do
            expect(page).to have_content('About')
            expect(page).to have_content('This section helps people understand how your practice started and introduces the original team.')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/contact")
        end

        def fill_in_origin_story_field
            fill_in('practice[origin_story]', with: @origin_story)
        end

        def fill_in_creator_fields
            fill_in('Name', with: @creator_name)
            fill_in('Role', with: @creator_role)
        end

        def save_button
            find('#practice-editor-save-button')
        end

        it 'should allow the user to update the origin story' do
            # create the origin story
            fill_in_origin_story_field
            save_button.click

            # see if the origin story shows up in the show view
            expect(page).to have_content('Origin story')
            within(:css, '#about') do
                expect(page).to have_content(@origin_story)
            end

            # Edit the origin story
            visit practice_about_path(@practice)
            fill_in('practice[origin_story]', with: 'This is an edited origin story.')
            save_button.click
            expect(page).to have_field('practice[origin_story]', with: "This is an edited origin story.")


            # check if the origin story with updated text shows up in the show view
            click_link(@practice.name)
            expect(page).to have_content('This is an edited origin story.')
        end

        it 'should allow the update team members' do
            fill_in_origin_story_field
            fill_in_creator_fields
            save_button.click
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

        it 'should allow the user to add multiple team members' do
            fill_in_origin_story_field
            fill_in_creator_fields
            save_button.click

            find('.add-practice-creator-link').click
            all('.practice-creator-name-input').last.set('Renji Abarai')
            all('.practice-creator-role').last.set('Lieutenant of squad six')
            save_button.click

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

        it 'should allow the user to delete team members' do
            fill_in_origin_story_field
            fill_in_creator_fields
            save_button.click

            find('.dm-origin-trash').click
            save_button.click

            expect(page).to have_field('Name:', with: nil)
            expect(page).to have_field('Role:', with: nil)
        end
    end
end
