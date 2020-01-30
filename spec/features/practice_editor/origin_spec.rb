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
        end

        it 'should be there' do
            expect(page).to have_content('Origin')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/overview")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/impact")
        end

        it 'should require the user to fill out the fields that are marked as required' do
            save_button = find('#practice-editor-save-button')
            save_button.click
            origin_story_message = page.find('.origin-story-textarea').native.attribute('validationMessage')
            expect(origin_story_message).to eq('Please fill out this field.')
            fill_in('practice_origin_story', with: 'This practice was founded on the basis of being awesome')
            save_button.click
            practice_creator_name_message = page.find('.practice-creator-name-input').native.attribute('validationMessage')
            expect(practice_creator_name_message).to eq('Please fill out this field.')
            fill_in('Name', with: 'Isshin Kurosaki')
            save_button.click
            practice_creator_role_message = page.find('.practice-creator-role').native.attribute('validationMessage')
            expect(practice_creator_role_message).to eq('Please fill out this field.')
        end

        it 'should allow the user to add a practice creator' do
            save_button = find('#practice-editor-save-button')
            fill_in('Origin story', with: 'This practice was founded on the basis of being awesome')
            fill_in('Name', with: 'Grimmjow Jaegerjaquez')
            fill_in('Role', with: 'Sixth Espada')
            save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Origin story:', with: 'This practice was founded on the basis of being awesome')
            expect(page).to have_field('Name:', with: 'Grimmjow Jaegerjaquez')
            expect(page).to have_field('Role:', with: 'Sixth Espada')
        end

        it 'should allow the user to add multiple practice creators' do
            save_button = find('#practice-editor-save-button')
            fill_in('Origin story:', with: 'This practice was founded on the basis of being awesome')
            fill_in('Name:', with: 'Grimmjow Jaegerjaquez')
            fill_in('Role:', with: 'Sixth Espada')
            save_button.click
            find('.add-practice-creator-link').click
            all('.practice-creator-name-input').last.set('Renji Abarai')
            all('.practice-creator-role').last.set('Lieutenant of squad six')
            save_button.click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('Origin story:', with: 'This practice was founded on the basis of being awesome')
            expect(page).to have_field('practice[practice_creators_attributes][0][name]', with: 'Grimmjow Jaegerjaquez')
            expect(page).to have_field('practice[practice_creators_attributes][0][role]', with: 'Sixth Espada')
            expect(page).to have_field('practice[practice_creators_attributes][1][name]', with: 'Renji Abarai')
            expect(page).to have_field('practice[practice_creators_attributes][1][role]', with: 'Lieutenant of squad six')
        end

        it 'should allow the user to delete practice creators' do
            save_button = find('#practice-editor-save-button')
            fill_in('Origin story:', with: 'This practice was founded on the basis of being awesome')
            fill_in('Name:', with: 'Gin Ichimaru')
            fill_in('Role:', with: 'Captain of squad three')
            save_button.click
            find('.origin-trash').click
            save_button.click
            expect(page).to have_field('Name:', with: nil)
            expect(page).to have_field('Role:', with: nil)
        end
    end
end