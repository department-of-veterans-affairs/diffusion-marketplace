require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @approver = User.create!(email: 'tosen.kaname@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @user = User.create!(email: 'jushiro.ukitake@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @user_2 = User.create!(email: 'tier.halibel@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
        @admin.add_role(User::USER_ROLES[0].to_sym)
        @approver.add_role(User::USER_ROLES[0].to_sym)
        @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', initiating_facility_type: 'other', tagline: 'Test tagline')
        @practice_editor = PracticeEditor.create!(practice: @practice, user: @user_2)
    end

    describe 'Authorization' do
        it 'should allow admin level users to edit a practice' do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content(@practice.name)
        end

        it 'should let an editor user edit a practice' do
            login_as(@approver, :scope => :user, :run_callbacks => false)
            @user_practice.update(approved: true, published: true)
            visit practice_path(@user_practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_link(href: "/practices/#{@user_practice.slug}/edit/metrics")
        end

        it 'should allow practice editors to edit a practice they\'re associated with' do
            login_as(@practice_editor, :scope => :user, :run_callbacks => false)
            visit practice_introduction_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content('Introduction')
            expect(page).to have_content('Introduce your practice and provide a brief summary to people who may be unfamiliar with it.')
        end

        it 'should not allow the following user types to edit a practice: non-admins, non-practice owners, and non-practice editors' do
            login_as(@user, :scope => :user, :run_callbacks => false)
            visit practice_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content(@practice.name)
            expect(page).to_not have_link(href: "/practices/#{@practice.slug}/edit/instructions")
        end
    end
end