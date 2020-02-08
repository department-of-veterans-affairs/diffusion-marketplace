require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Collaborators page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_collaborators_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
        end

        it 'should be there' do
            expect(page).to have_content('Collaborators')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/instructions")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/overview")
        end
    end
end