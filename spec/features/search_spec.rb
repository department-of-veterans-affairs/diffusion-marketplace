require 'rails_helper'

describe 'Search', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
    @user_practice2 = Practice.create!(name: 'Another Best Practice', user: @user, initiating_facility: 'vc_0508V', tagline: 'Test tagline 2')
    login_as(@user, :scope => :user, :run_callbacks => false)
  end

  describe 'results' do
    it 'should show practices that are approved and published'do
      @user_practice.update(published: true, approved: true)
      visit '/search'
      expect(page).to be_accessible.according_to :wcag2a, :section508

      fill_in('Type keywords to find a practice', with: 'Test')
      click_button('Search')

      expect(page).to be_accessible.according_to :wcag2a, :section508

      # test facility data map for name, negative case
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice.initiating_facility.upcase)
      expect(page).to have_content('1 result for "Test"')

      # do not show a practice that is not approved/published
      fill_in('Type keywords to find a practice', with: 'practice')
      click_button('Search')

      expect(page).to have_content('1 result for "practice"')

      # show practices that are approved/published
      @user_practice2.update(published: true, approved: true)
      visit '/search'

      fill_in('Type keywords to find a practice', with: 'practice')
      click_button('Search')

      expect(page).to be_accessible.according_to :wcag2a, :section508

      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice2.name)
      expect(page).to have_content('2 results for "practice"')

      # test facility data map for name, positive case
      expect(page).to have_content('Tacoma Vet Center'.upcase)

    end

  end

end