require 'rails_helper'

describe 'Admin - Users', type: :feature do
  let(:user_a) { create(:user, email: 'mr.krabs@va.gov') }
  let(:user_b) { create(:user, email: 'patrick.star@va.gov') }
  let(:user_c) { create(:user, email: 'spongebob@va.gov') }

  before do
    admin = create(:user, :admin, email: 'sandy.cheeks@va.gov')
    login_as(admin, scope: :user, run_callbacks: false)
  end

  describe "Updating granted_public_bio attribute" do
    before do
      Rails.cache.clear
    end

    it "updates the granted_public_bio attribute and refreshes the cache" do
      update_user("password12345!")
      check "Granted public bio"
      click_button "Update User"

      expect(page).to have_content("User was successfully updated.")
      expect(user_a.reload.granted_public_bio).to be(true)

      cached_users = Rails.cache.read("users_with_public_bio")
      expect(cached_users).to include(user_a)

      update_user("password12346!")
      uncheck "Granted public bio"
      click_button "Update User"
      cached_users = Rails.cache.read("users_with_public_bio")
      expect(cached_users).not_to include(user_a)
    end
  end

  def update_user(password)
    visit admin_user_path(user_a)
    click_link "Edit User"
    fill_in "user[password]", with: password
    fill_in "user[password_confirmation]", with: password
  end
end