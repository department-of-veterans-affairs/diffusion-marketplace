require 'rails_helper'
describe 'Practice partners pages', type: :feature do
  before do
    @pp = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @pr_1 = Practice.create!(name: 'A public practice', approved: true, published: true, enabled: true, is_public: true, initiating_facility_type: 'other', user: @user2)
    @pr_2 = Practice.create!(name: 'practice two', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_3 = Practice.create!(name: 'practice three', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_4 = Practice.create!(name: 'practice four', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_5 = Practice.create!(name: 'practice five', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_6 = Practice.create!(name: 'practice six', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_7 = Practice.create!(name: 'practice seven', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_8 = Practice.create!(name: 'practice eight', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_9 = Practice.create!(name: 'practice nine', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_10 = Practice.create!(name: 'practice ten', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_11 = Practice.create!(name: 'practice eleven', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_12 = Practice.create!(name: 'practice twelve', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_13 = Practice.create!(name: 'practice thirteen', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    Practice.create!(name: 'random practice', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_1)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_2)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_3)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_4)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_5)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_6)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_7)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_8)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_9)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_10)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_11)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_12)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @pr_13)
  end

  context 'for a logged in user' do
    before do
      login_as(@user, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
    end

    it 'should navigate to strategic sponsors list page' do
      visit '/partners'
      # TODO: this is timing out in CI
      # expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(current_path).to eq('/partners')
    end

    it 'should show the initiating facility\'s name' do
      @pr_1.update(initiating_facility: 'Foobar Facility')
      visit '/partners/diffusion-of-excellence'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@pr_1.name)
      expect(page).to have_content('Foobar Facility')
    end

    it 'should display the initiating facility\'s initiating facility property if it is not found in the map' do
      @pr_1.update(initiating_facility: 'Test facility')
      visit '/partners/diffusion-of-excellence'
      expect(page).to have_content(@pr_1.name)
      expect(page).to have_content('Test facility')
    end

    it 'should paginate the practice cards if there are more than 12 cards' do
      visit '/partners/diffusion-of-excellence'
      expect(page).to have_content('Load more')
      pr_card_count = find_all('.dm-practice-card').size
      expect(pr_card_count).to eq(12)
      find('.paginated-partner-practices-page-2-link').click
      expect(page).to have_content('practice two')
      updated_pr_card_count = find_all('.dm-practice-card').size
      expect(updated_pr_card_count).to eq(13)
      expect(page).to have_no_content('Load more')
      expect(page).to have_no_content('random practice')
    end
  end

  context 'for a public user' do
    it 'should only display the public practice' do
      visit '/partners/diffusion-of-excellence'
      pr_card_count = find_all('.dm-practice-card').size
      expect(pr_card_count).to eq(1)
      expect(page).to have_no_content('Load more')
      expect(page).to have_content('A public practice')
      expect(page).to have_no_content('random practice')
    end
  end
end
