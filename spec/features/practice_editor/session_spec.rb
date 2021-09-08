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

  it 'should not allow a user to edit a practice that is locked' do
    #introduction page.
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit practice_introduction_path(@practice)
    logout(@user)
    login_as(@user_2, :scope => :user, :run_callbacks => false)
    locked_msg = 'You cannot edit this innovation since it is currently being edited by satoru.gojo@va.gov'
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

  it 'should allow a user to extend their current session' do
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit practice_introduction_path(@practice_2)
    session_start_time = PracticeEditorSession.last.session_start_time
    PracticeEditorSession.last.update_attributes(session_start_time: DateTime.current - 14.minutes)
    visit practice_introduction_path(@practice_2)
    page.driver.browser.switch_to.alert.accept
    sleep 0.3
    new_session_start_time = PracticeEditorSession.last.session_start_time

    expect(new_session_start_time).not_to eq(session_start_time)
  end

  it 'should save updates made to the practice if the user chooses to end their session and there are no required fields' do
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

  describe 'practice with required fields when a user cancels the session' do
    before do
      login_as(@user, :scope => :user, :run_callbacks => false)
    end

    it 'should not save and redirect to metrics when required fields for saving' do
      visit practice_introduction_path(@practice_2)
      session = PracticeEditorSession.last
      session.update(session_start_time: DateTime.now - 14.minutes)
      visit practice_introduction_path(@practice_2)
      page.driver.browser.switch_to.alert.dismiss
      expect(@practice_2.updated_at_changed?).to eq(false)
      expect(page).to have_current_path(practice_metrics_path(@practice_2))
      expect(page).to have_content('The practice was not saved due to one or more required fields not being filled out.')
    end

    it 'should not save and redirect to metrics with required nested inputs' do
      visit practice_implementation_path(@practice_2)
      find_all('.practice-input').first.set('Fred')
      find('#practice-editor-save-button').click
      expect(page).to have_content('Practice was successfully updated')
      expect(page).to have_current_path(practice_implementation_path(@practice_2))
      PracticeResource.create!(practice: @practice_2, link_url:'www.google.com', name: "search stuff", resource_type: "core", media_type: "link")
      visit practice_implementation_path(@practice_2)
      session = PracticeEditorSession.last
      session.update(session_start_time: DateTime.now - 14.minutes)
      visit practice_implementation_path(@practice_2)
      page.driver.browser.switch_to.alert.dismiss
      expect(@practice_2.updated_at_changed?).to eq(false)
      expect(page).to have_current_path(practice_metrics_path(@practice_2))
      expect(page).to have_content('The practice was not saved due to one or more required fields not being filled out.')
    end
  end

  describe 'session expires' do
    it 'should let another user take a session' do
      login_as(@user, :scope => :user, :run_callbacks => false)
      visit practice_introduction_path(@practice_2)
      session = PracticeEditorSession.last
      session.update(session_start_time: DateTime.now - 20.minutes)
      logout(@user)
      login_as(@user_2, :scope => :user, :run_callbacks => false)
      visit practice_introduction_path(@practice_2)
      first_session = PracticeEditorSession.first
      last_session = PracticeEditorSession.last
      expect(first_session[:session_end_time]).not_to eq(nil)
      expect(last_session.user[:email]).to eq("yuji.itadori@va.gov")
      expect(page).to have_current_path(practice_introduction_path(@practice_2))
    end
  end
end