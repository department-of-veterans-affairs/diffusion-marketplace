require 'rails_helper'

describe 'Admin email all editors button', type: :feature, js: true do
  let(:admin) { create(:user, :admin) }
  let!(:users) { create_list(:user, 3) }
  let!(:practices) { create_list(:practice, 3, user: admin) }

  before do
    ActionMailer::Base.deliveries.clear

    practices.each do |practice|
      create(:practice_editor, user: users.first, practice: practice)
    end

    users.each_with_index do |user, index|
      create(:practice_editor, user: user, practice: practices[index])
    end

    login_as(admin, scope: :user, run_callbacks: false)
    visit admin_practices_path
  end

  it 'sends an email to all editors when the button is clicked' do
    expect(page).to have_content('Published Practices QUERI Download')
    
    click_link 'Send Email to All Editors'

    fill_in 'emailSubject', with: 'Important Update'
    find('#emailMessage').click


    execute_script("tinyMCE.get('emailMessage').setContent('Please review the latest changes.')")

    click_button 'Preview Email'

    within('#previewModal') do
      click_button 'Send Email'
      page.driver.browser.switch_to.alert.accept
    end

    expect(page).to have_current_path(admin_practices_path)
    expect(page).to have_content('Your batch email to Innovation editors has been sent.')

    (users + [admin]).each do |user|
      email = ActionMailer::Base.deliveries.select { |e| e.to.include?(user.email) }.first
      expect(email).not_to be_nil
      expect(email.subject).to eq 'Important Update'
      
      user_practices = user == admin ? practices : PracticeEditor.where(user: user).map(&:practice)
      user_practices.each do |practice|
        expect(email.body.encoded).to include practice_path(practice)
      end
    end
  end
end
