require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
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
            find('#practice-editor-save-button').click
            origin_story_message = page.find('.origin-story-textarea').native.attribute('validationMessage')
            expect(origin_story_message).to eq('Please fill out this field.')
            fill_in('practice_1_origin_story_textarea', with: 'This practice was founded on the basis of being awesome')
            find('#practice-editor-save-button').click
            practice_creator_name_message = page.find('.practice-creator-name-input').native.attribute('validationMessage')
            expect(practice_creator_name_message).to eq('Please fill out this field.')
            fill_in('practice_creator__name', with: 'Isshin Kurosaki')
            find('#practice-editor-save-button').click
            practice_creator_role_message = page.find('.practice-creator-role').native.attribute('validationMessage')
            expect(practice_creator_role_message).to eq('Please fill out this field.')
        end

        it 'should allow the user to add a practice creator' do
            fill_in('practice_1_origin_story_textarea', with: 'This practice was founded on the basis of being awesome')
            fill_in('practice_creator__name', with: 'Grimmjow Jaegerjaquez')
            fill_in('practice_creator__role', with: 'Sixth Espada')
            find('#practice-editor-save-button').click
            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('practice_1_origin_story_textarea', with: 'This practice was founded on the basis of being awesome')
            expect(page).to have_field('practice_creator_1_name', with: 'Grimmjow Jaegerjaquez')
            expect(page).to have_field('practice_creator_1_role', with: 'Sixth Espada')
        end

        it 'should allow the user to add multiple practice creators' do
            fill_in('practice_1_origin_story_textarea', with: 'This practice was founded on the basis of being awesome')
            fill_in('practice_creator__name', with: 'Grimmjow Jaegerjaquez')
            fill_in('practice_creator__role', with: 'Sixth Espada')
            find('#practice-editor-save-button').click
            debugger
            fill_in('practice_creator__name', with: 'Renji Abarai')
            fill_in('practice_creator__role', with: 'Lieutenant of squad six')
            find('#practice-editor-save-button').click
        end
    end
end