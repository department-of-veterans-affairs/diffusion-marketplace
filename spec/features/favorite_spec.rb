require 'rails_helper'

describe 'Favorites', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice1 = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', featured: true)
    @practice2 = Practice.create!(name: 'The Best Practice Ever!', approved: true, published: true, tagline: 'Test tagline', featured: true)
    @user_practice = UserPractice.create!(user: @user, practice: @practice2, favorited: true)
  end

  describe 'Home page' do
    describe 'logged out' do
      it 'should not show a favorite button' do
        visit '/'
        expect(page).not_to have_selector('.favorite-practice-button')
      end
    end

    describe 'logged in' do
      before do
        login_as(@user, :scope => :user, :run_callbacks => false)
        visit '/'
      end

      it 'should show a favorite button' do
        expect(page).to have_selector('.favorite-practice-button')
      end

      it 'should allow adding a favorite' do
        favorite_button = find(:css, "#favorite-button-#{@practice1.id}")
        favorite_button.click
        expect(favorite_button).to have_selector('.fas')
      end

      it 'should allow removing a favorite' do
        favorite_button = first(:css, "#favorite-button-#{@practice2.id}")
        favorite_button.click
        expect(favorite_button).to have_selector('.far')
      end
    end
  end

  describe 'Practice list page' do
    describe 'logged out' do
      it 'should not show a favorite button' do
        visit '/practices'
        expect(page).not_to have_selector('.favorite-practice-button')
      end
    end

    describe 'logged in' do
      before do
        login_as(@user, :scope => :user, :run_callbacks => false)
        visit '/practices'
      end

      it 'should show a favorite button' do
        expect(page).to have_selector('.favorite-practice-button')
      end

      it 'should allow adding a favorite' do
        favorite_button = find(:css, "#favorite-button-#{@practice1.id}")
        favorite_button.click
        expect(favorite_button).to have_selector('.fas')
      end

      it 'should allow removing a favorite' do
        favorite_button = first(:css, "#favorite-button-#{@practice2.id}")
        favorite_button.click
        expect(favorite_button).to have_selector('.far')
      end
    end
  end

  describe 'Practice show page' do
    describe 'logged out' do
      it 'should not show a favorite link' do
        visit '/practices/the-best-practice-ever'
        expect(page).not_to have_content('Bookmark')
      end
    end

    describe 'logged in' do
      before do
        login_as(@user, :scope => :user, :run_callbacks => false)
      end

      it 'should show a favorite link' do
        visit '/practices/the-best-practice-ever'
        expect(page).to have_selector('.dm-favorite-practice-link')
      end

      it 'should allow adding a favorite' do
        visit '/practices/a-public-practice'
        favorite_link = find(:css, '.dm-favorite-practice-link')
        favorite_link.click
        expect(favorite_link).to have_content('Bookmarked')
      end

      it 'should allow removing a favorite' do
        visit '/practices/the-best-practice-ever'
        favorite_link = find(:css, '.dm-favorite-practice-link')
        favorite_link.click
        expect(favorite_link).to have_content('Bookmark')
      end
    end
  end

  describe 'User show page' do
    describe 'logged out' do
      before do
        visit "/users/#{@user.id}"
      end

      it 'should have a favorites section' do
        expect(page).to have_content('Favorited practices')
      end

      it 'should not show a favorite button' do
        expect(page).not_to have_selector('.favorite-practice-button')
      end
    end

    describe 'logged in' do
      before do
        login_as(@user, :scope => :user, :run_callbacks => false)
        visit "/users/#{@user.id}"
      end

      it 'should have a favorites section' do
        expect(page).to have_content('Favorited practices')
      end

      it 'should show a favorite button' do
        expect(page).to have_selector('.favorite-practice-button')
      end

      it 'should allow removing a favorite' do
        favorite_button = first(:css, "#favorite-button-#{@practice2.id}")
        favorite_button.click
        expect(favorite_button).to have_selector('.far')
      end
    end
  end
end
