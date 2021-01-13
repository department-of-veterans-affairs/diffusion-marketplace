require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Side navigation' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_instructions_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
        end

        it 'should be there' do
            expect(page).to have_css('.usa-sidenav__item', count: 3)
        end

        it 'should not have a link to Collaborators' do
            expect(page).not_to have_link('Collaborators', href: "/practices/#{@practice.slug}/edit/collaborators")
        end

        it 'should navigate the user around the editor when they click on the section names' do
          visit '/practices/a-public-practice/edit/introduction'
            page.has_css?('#introduction')
            expect(page).to have_content('Introduce your practice and provide a brief summary to people who may be unfamiliar with it.')

            click_link 'Adoptions'
            page.has_css?('#adoptions')
            expect(page).to have_content('Share which facilities have successfully adopted your practice. All adoptions roll up to the VAMC level. Aim to update this data quarterly.')
        end
    end
end