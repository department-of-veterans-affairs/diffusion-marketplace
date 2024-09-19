require 'rails_helper'

describe 'Admin - Practices', type: :feature do
  before do
    @admin = create(:user, :admin, email: 'sandy.cheeks@va.gov')
    @editor = create(:user, email: 'patrick.star@va.gov')
    @non_admin = create(:user, email: 'spongebob@va.gov')
    @enabled_practice = Practice.create!(name: 'Enabled practice', approved: true, published: true, enabled: true, date_initiated: Time.now(), user: @admin)
    login_as(@admin, scope: :user, run_callbacks: false)
  end

  describe 'actions' do
    it 'disable' do
      visit admin_practices_path
      within('#practice_1') do
        expect(page).to have_link('Disable')
        click_link('Disable')
      end
      visit practice_path(@enabled_practice)
      expect(page).to have_content(@enabled_practice.name)
      logout
      visit practice_path(@enabled_practice)
      expect(page).not_to have_content(@enabled_practice.name)
      expect(page).to have_current_path(root_path)
      login_as(@non_admin, scope: :user, run_callbacks: false)  
      visit practice_path(@enabled_practice)
      expect(page).not_to have_content(@enabled_practice.name)
      expect(page).to have_current_path(root_path)
    end
  end

  def save_page
    find('input[type="submit"]', match: :first).click
  end
end
