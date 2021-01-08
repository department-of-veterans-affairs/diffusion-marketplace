require 'rails_helper'
describe 'Practice partners pages', type: :feature do
  before do
    @pp = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best practices through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'A public practice', approved: true, published: true, initiating_facility_type: 'other')
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @user_practice)
  end

  it 'should navigate to strategic sponsors list page' do
    visit '/'
    within(:css, 'footer') do
      find(:css, 'a', text: 'Partners').click
    end
    # TODO: this is timing out in CI
    # expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(current_path).to eq('/partners')
  end

  it 'should show the initiating facility\'s name' do
    @user_practice.update(initiating_facility: 'Foobar Facility')
    visit '/partners/diffusion-of-excellence'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content(@user_practice.name)
    expect(page).to have_content('Foobar Facility')
  end

  it 'should display the initiating facility\'s initiating facility property if it is not found in the map' do
    @user_practice.update(initiating_facility: 'Test facility')
    visit '/partners/diffusion-of-excellence'
    expect(page).to be_accessible.according_to :wcag2a, :section508

    expect(page).to have_content(@user_practice.name)
    expect(page).to have_content('Test facility')
  end
end
