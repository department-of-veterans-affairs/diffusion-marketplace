require 'rails_helper'
describe 'Practice editor sessions', type: :feature do
  before do
    @user = User.create!(email: 'satoru.gojo@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user_2 = User.create!(email: 'yuji.itadori@va.gov', first_name: 'Yuji', last_name: 'Itadori', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'An unpublished practice', slug: 'an-unpublished-practice', approved: true, published: false, tagline: 'Test tagline', user: @user)
    @practice_2 = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @user)
    @user.add_role(User::USER_ROLES[0].to_sym)
    @user_2.add_role(User::USER_ROLES[0].to_sym)
  end

  it 'should not allow a user to edit practice if practice is locked for editing' do
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit practice_introduction_path(@practice)
    logout(@user)
    login_as(@user_2, :scope => :user, :run_callbacks => false)
    visit practice_introduction_path(@practice)
    expect(page).to have_content('You cannot edit this practice since it is currently being edited by satoru.gojo@va.gov')
  end

  it 'should save updates made to the practice editor page the user is currently on if they choose to end their session' do
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit practice_overview_path(@practice)

    fill_in('practice_overview_problem', with: 'test')
    fill_in('practice_overview_solution', with: 'test')
    fill_in('practice_overview_results', with: 'test')
    PracticeEditorSession.last.update_attributes(session_start_time: DateTime.current - 28.minutes)
    click_button('Save')
    page.driver.browser.switch_to.alert.dismiss
    expect(page).to have_current_path(practice_metrics_path(@practice))
    expect(page).to have_content("Your editing session for #{@practice.name} has ended. Your edits have been saved and you have been returned to the Metrics page.")
  end
end