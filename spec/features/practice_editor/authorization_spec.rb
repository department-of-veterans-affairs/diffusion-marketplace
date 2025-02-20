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
        @user_practice = Practice.create!(name: 'The Best Innovation Ever!', user: @user, initiating_facility: 'Test facility name', initiating_facility_type: 'other', tagline: 'Test tagline')
        @practice_editor = PracticeEditor.create!(innovable: @practice, user: @user_2, email: @user_2.email)
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
            expect(page).to have_link(href: "/innovations/#{@user_practice.slug}/edit/editors")
        end

        it 'should allow practice editors to edit a practice they\'re associated with' do
            visn_1 = Visn.create!(id: 1, name: "VA New England Healthcare System", number: 1)
            VaFacility.create!(visn: visn_1, station_number: "640A0", official_station_name: "Palo Alto VA Medical Center-Menlo Park", common_name: "Palo Alto-Menlo Park", street_address_state: "CA")

            login_as(@user_2, :scope => :user, :run_callbacks => false)
            visit practice_introduction_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content('Introduction')
        end

        it 'should not allow the following user types to edit a practice: non-admins, non-practice owners, and non-practice editors' do
            login_as(@user, :scope => :user, :run_callbacks => false)
            visit practice_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content(@practice.name)
            expect(page).to_not have_link(href: "/innovations/#{@practice.slug}/edit/instructions")
        end
    end
end