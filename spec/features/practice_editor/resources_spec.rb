require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Resources Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_resources_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
        end

        it 'should be there' do
            expect(page).to have_content('Resources')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/documentation")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/complexity")
        end

        it 'should require the user to select one of the cost to implement options' do
            @save_button.click
            resource_message = all('.resource-radio').first.native.attribute('validationMessage')
            expect(resource_message).to eq('Please select one of these options.')
        end

        it 'should allow the user to select one of the cost to implement options' do
            all('.usa-radio__label').first.click
            @save_button
            expect(all('.resource-radio').first).to be_checked
        end
    end
end