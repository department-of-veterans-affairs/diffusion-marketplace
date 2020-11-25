require 'rails_helper'

describe 'Recommended for you page', type: :feature do
  before do
    @user1 = User.create!(email: 'kuchiki.byakuya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(
        email: 'kuchiki.rukia@soulsociety.com',
        password: 'Password123',
        password_confirmation: 'Password123',
        skip_va_validation: true,
        confirmed_at: Time.now,
        accepted_terms: true,
        location: 'C.W. Bill Young Department of Veterans Affairs Medical Center'
    )
    @practice = Practice.create!(
        name: 'A public practice',
        approved: true,
        published: true,
        tagline: 'Test tagline',
        support_network_email: 'test@test.com'
    )
    @practice2 = Practice.create!(name: 'A second public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@test.com')
    @practice3 = Practice.create!(name: 'A third public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@test.com')
    @practice4 = Practice.create!(name: 'A fourth public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@test.com')
    @practice_facility = PracticeOriginFacility.create!(practice: @practice, facility_id: '516')
    @practice_facility2 = PracticeOriginFacility.create!(practice: @practice2, facility_id: '516')
    @practice_facility3 = PracticeOriginFacility.create!(practice: @practice3, facility_id: '516')
    @practice_facility4 = PracticeOriginFacility.create!(practice: @practice4, facility_id: '516')
    @user_practice = UserPractice.create!(practice: @practice, user: @user2, favorited: true, time_favorited: DateTime.now.midnight - 10.days)
    @user_practice2 = UserPractice.create!(practice: @practice2, user: @user2, favorited: true, time_favorited: DateTime.now.midnight - 8.days)
    @user_practice3 = UserPractice.create!(practice: @practice3, user: @user2, favorited: true, time_favorited: DateTime.now.midnight - 6.days)
    @user_practice4 = UserPractice.create!(practice: @practice4, user: @user2, favorited: true, time_favorited: nil)
  end

  def login_and_visit_recommended_path(user)
    login_as(user, scope: :user, run_callbacks: false)
    visit '/recommended-for-you'
  end

  describe 'Authorization' do
    it 'should redirect the user to the homepage if they are not logged in' do
      visit '/recommended-for-you'

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('Diffusion Marketplace')
      expect(page.current_path).to eq root_path
    end

    it 'should allow the user to visit the recommended for you page if they are logged in' do
      login_and_visit_recommended_path(@user1)

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('Recommended for you')
      expect(page).to have_content('Based on your location')
      expect(page.current_path).to eq recommended_for_you_path
    end
  end

  describe 'Page content' do
    it 'should not display the bookmarked practices section if the user does not have any bookmarked practices' do
      login_and_visit_recommended_path(@user1)

      expect(page).to_not have_content('Your bookmarked practices')
    end

    it 'should display a link to yourit.va.gov along with some copy if the user does not have any practices based on their location' do
      login_and_visit_recommended_path(@user1)

      expect(page).to have_content('You don’t have a location listed in GAL yet.')
      expect(page).to have_link('Submit a ticket to YourIT', href: 'https://yourit.va.gov')
    end

    it 'should display the bookmarked practices section if the user has any bookmarked practices' do
      login_and_visit_recommended_path(@user2)

      expect(page).to have_content('Your bookmarked practices')
      expect(page).to have_content('A public practice')
      expect(page).to have_content('A second public practice')
    end

    it 'should display up to three practices that share the same location as the user' do
      login_and_visit_recommended_path(@user2)

      within(:css, '.user-location-practices') do
        expect(page).to have_selector('.dm-practice-card', count: 3)
      end
    end

    it 'should take the user to the search page with a query of their location if there are more than three practices that share their location and click the link' do
      login_and_visit_recommended_path(@user2)

      click_link('See more practices')

      expect(page).to have_content('Search results')
      expect(page).to have_content("4 results for #{@user2.location}:")
    end
  end

  describe 'Pagination' do
    it 'should only show the first three bookmarked practices on initial page load' do
      login_and_visit_recommended_path(@user2)

      expect(page).to have_content('Your bookmarked practices')
      within(:css, '.paginated-favorite-practices') do
        expect(page).to have_selector('.dm-practice-card', count: 3)
      end
    end

    it 'should display the next set of bookmarked practices when the user clicks on the load more link' do
      login_and_visit_recommended_path(@user2)

      within(:css, '.paginated-favorite-practices') do
        expect(page).to have_selector('.dm-practice-card', count: 3)
      end

      find('.paginated-favorite-practices-page-2-link').click
      within(:css, '.paginated-favorite-practices') do
        expect(page).to have_selector('.dm-practice-card', count: 4)
      end
    end

    it 'should remove load more link if the user started with four or more bookmarked practices, but after un-bookmarking, has less than four' do
      login_and_visit_recommended_path(@user2)

      expect(page).to have_selector('.paginated-favorite-practices-page-2-link')

      all('.dm-practice-bookmark-btn').first.click
      expect(page).to_not have_selector('.paginated-favorite-practices-page-2-link')
    end
  end
end