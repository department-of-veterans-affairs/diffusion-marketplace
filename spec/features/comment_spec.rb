require 'rails_helper'

describe 'Comments', type: :feature do
    before do
        @user1 = User.create!(email: 'hisagi.shuhei@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
        @user2 = User.create!(email: 'momo.hinamori@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
        @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline')
        @departments = [
            Department.create!(name: 'Admissions', short_name: 'admissions'),
            Department.create!(name: 'None', short_name: 'none'),
            Department.create!(name: 'All departments equally - not a search differentiator', short_name: 'all'),
        ]
        @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    end

    describe 'Authorization' do
        it 'Should allow authenticated users to view comments' do
            # Login as an authenticated user and visit the practice page
            login_as(@user1, :scope => :user, :run_callbacks => false)
            visit practice_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content(@practice.name)
            expect(page).to have_current_path(practice_path(@practice))
            expect(page).to have_css('.commontator')
        end

        it 'Should allow authenticated users to post comments' do
            #Login as an authenticated user, visit the practice page, and create a comment
            login_as(@user2, :scope => :user, :run_callbacks => false)
            visit practice_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content(@practice.name)
            expect(page).to have_current_path(practice_path(@practice))
            expect(page).to have_css('.commontator')
            fill_in('comment[body]', with: 'Hello world')
            click_button('commit')
            visit practice_path(@practice)
            expect(page).to have_css('.commontator-comment-1')
        end

        it 'Should'

        it 'Should not allow unauthenticated users to view or post comments' do
            # Try to visit a practice page without being logged in
            visit practice_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            expect(page).to have_content(@practice.name)
            expect(page).to have_current_path(practice_path(@practice))
            expect(page).to have_content('Login to see full practice')
        end
    end
end