require 'rails_helper'
describe 'Practice partners pages', type: :feature, js: true do
  before do
    @pp = create(:practice_partner, name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @pp_2 = create(:practice_partner, :not_major_partner, name: 'Awesome Practice Partner', short_name: 'APP', description: 'Hello world')
    @user = create(:user, email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = create(:user, email: 'patrick.star@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = create(:user, email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = create(:user, email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @pr_1 = create(:practice, name: 'A public practice', approved: true, published: true, enabled: true, is_public: true, initiating_facility_type: 'other', user: @user2)
    @pr_2 = create(:practice, name: 'practice two', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_3 = create(:practice, name: 'practice three', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_4 = create(:practice, name: 'practice four', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_5 = create(:practice, name: 'practice five', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_6 = create(:practice, name: 'practice six', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_7 = create(:practice, name: 'practice seven', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_8 = create(:practice, name: 'practice eight', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_9 = create(:practice, name: 'practice nine', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_10 = create(:practice, name: 'practice ten', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_11 = create(:practice, name: 'practice eleven', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_12 = create(:practice, name: 'practice twelve', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    @pr_13 = create(:practice, name: 'practice thirteen', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    create(:practice, name: 'random practice', approved: true, published: true, enabled: true, initiating_facility_type: 'other', user: @user2)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_1)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_2)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_3)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_4)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_5)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_6)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_7)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_8)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_9)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_10)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_11)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_12)
    create(:practice_partner_practice, practice_partner: @pp, innovable: @pr_13)
  end

  context 'for a logged in user' do
    before do
      login_as(@user, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
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

    it 'should redirect the user to the homepage if they try to view a minor practice partner\'s show page' do
      @pp.update(is_major: false)
      visit '/partners/diffusion-of-excellence'
      expect(page).to_not have_current_path('/partners/diffusion-of-excellence')
      expect(page).to have_current_path('/')
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
