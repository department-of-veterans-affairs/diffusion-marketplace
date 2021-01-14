require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @approver = User.create!(email: 'tosen.kaname@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @user = User.create!(email: 'jushiro.ukitake@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
        @approver.add_role(User::USER_ROLES[0].to_sym)
        @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', initiating_facility_type: 'other', tagline: 'Test tagline')
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

        it 'should not allow non-admin level users to edit a practice' do
            login_as(@user, :scope => :user, :run_callbacks => false)
            visit practice_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content(@practice.name)
            expect(page).to_not have_link(href: "/practices/#{@practice.slug}/edit/instructions")
        end
    end
end