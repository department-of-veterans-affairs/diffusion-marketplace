require 'rails_helper'

describe 'Admin email all editors button', type: :feature, js: true do
  let(:admin) { create(:user, :admin) }
  let!(:users) { create_list(:user, 3) }
  let!(:practices) { create_list(:practice, 3, user: admin) }

  before do
    ActionMailer::Base.deliveries.clear
    # Assign one user as an editor to all practices
    practices.each do |practice|
      create(:practice_editor, user: users.first, practice: practice)
    end

    # Assign the rest of the users as editors to only one practice
    users.each_with_index do |user, index|
      create(:practice_editor, user: user, practice: practices[index])
    end

    login_as(admin, scope: :user, run_callbacks: false)
    visit admin_practices_path
  end

  it 'sends an email to all editors when the button is clicked' do
    expect(page).to have_content('Published Practices QUERI Download')
    
    click_link 'Send Email to All Editors'

    fill_in 'Email Subject', with: 'Important Update'
    fill_in 'Message', with: 'Please review the latest changes.'
    click_button 'Send Email'

    expect(page).to have_current_path(admin_practices_path)
    expect(page).to have_content('Emails are being sent.')

    # Verify the correct number of emails are sent
    expect(ActionMailer::Base.deliveries.size).to eq users.size + 1  # including admin

    # Verify that each editor (including admin) received an email with links to their respective practices
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
