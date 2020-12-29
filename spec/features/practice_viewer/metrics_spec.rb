require 'rails_helper'

describe 'Metrics section', type: :feature, js: true do
  before do
    @user1 = User.create!(email: 'hisagi.shuhei@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user1.add_role(User::USER_ROLES[0].to_sym)
    @user2 = User.create!(email: 'momo.hinamori@soulsociety.com', first_name: 'Momo', last_name: 'H', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@test.com')
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @practice_email = PracticeEmail.create!(practice: @practice, address: 'test2@test.com')
  end

  describe 'Authorization' do
    it 'Should allow authenticated users to view metrics' do
      # Login as an authenticated user and visit the practice page
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      click_link('Edit')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
        #expect(page).to have_current_path(metrics_path(@practice))
        #expect(page).to have_css('.commontator')
    end

    # it 'Should allow authenticated users to post comments' do
    #   # Login as an authenticated user, visit the practice page, and create a comment
    #   login_as(@user2, :scope => :user, :run_callbacks => false)
    #   visit practice_path(@practice)
    #   expect(page).to be_accessible.according_to :wcag2a, :section508
    #   expect(page).to have_content(@practice.name)
    #   expect(page).to have_css('.commontator')
    #   fill_in('comment[body]', with: 'Hello world')
    #   click_button('commit')
    #   expect(page).to have_css('#commontator-comment-1')
    # end
    #
    # it 'Should not allow unauthenticated users to view or post comments' do
    #   # Try to visit a practice page without being logged in
    #   visit practice_path(@practice)
    #   expect(page).to be_accessible.according_to :wcag2a, :section508
    #   expect(page).to have_content(@practice.name)
    #   expect(page).to have_current_path(practice_path(@practice))
    #   expect(page).to have_content('Login to see full practice')
    # end
  end
end