require 'rails_helper'
describe 'Practice editor sessions', type: :feature, js: true do
  before do
    @user = User.create!(email: 'satoru.gojo@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user_2 = User.create!(email: 'yuji.itadori@va.gov', first_name: 'Yuji', last_name: 'Itadori', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'An unpublished practice', slug: 'an-unpublished-practice', approved: true, published: false, tagline: 'Test tagline', user: @user)
    @practice_2 = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @user)
    @user.add_role(User::USER_ROLES[0].to_sym)
    @user_2.add_role(User::USER_ROLES[0].to_sym)
  end

  it 'should not allow a user to edit a practice that is locked' do
    #intorduction page.
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit practice_introduction_path(@practice)
    logout(@user)
    login_as(@user_2, :scope => :user, :run_callbacks => false)
    locked_msg = 'You cannot edit this practice since it is currently being edited by satoru.gojo@va.gov'
    visit practice_introduction_path(@practice)
    expect(page).to have_content(locked_msg)

    visit practice_adoptions_path(@practice)
    expect(page).to have_content(locked_msg)

    visit practice_editors_path(@practice)
    expect(page).to have_content(locked_msg)

    visit practice_implementation_path(@practice)
    expect(page).to have_content(locked_msg)

    visit practice_overview_path(@practice)
    expect(page).to have_content(locked_msg)

    visit practice_contact_path(@practice)
    expect(page).to have_content(locked_msg)

    visit practice_about_path(@practice)
    expect(page).to have_content(locked_msg)
  end
end