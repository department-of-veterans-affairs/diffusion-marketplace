require 'rails_helper'

describe 'Contact section', type: :feature, js: true do
  def set_data
    @user1 = User.create!(email: 'hisagi.shuhei@va.gov', first_name: 'Shuhei', last_name: 'Hisagi', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'momo.hinamori@va.gov', first_name: 'Momo', last_name: 'H', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user3 = User.create!(email: 'testp13423041@va.gov', first_name: 'Test', last_name: 'Account', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'testp13423041@va.gov', user: @user1)
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @practice_email = PracticeEmail.create!(practice: @practice, address: 'testp13423041@va.gov')
  end

  describe 'Authorization' do
    before do
      set_data
    end

    it 'Should allow authenticated users to view comments' do
      # Login as an authenticated user and visit the practice page
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
      expect(page).to have_current_path(practice_path(@practice))
      expect(page).to have_css('.commontator')
    end

    it 'Should allow authenticated users to post comments' do
      # Login as an authenticated user, visit the practice page, and create a comment
      login_as(@user2, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
      expect(page).to have_content("Other")
      expect(page).to have_css('.commontator')
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
      expect(page).to have_css('#commontator-comment-1')
    end

    it 'Should not allow unauthenticated users to view or post comments' do
      # Try to visit a practice page without being logged in
      visit practice_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
      expect(page).to have_current_path(practice_path(@practice))
      expect(page).to have_content('Login to see full practice')
    end
  end

  describe 'Commenting flow' do
    before do
      set_data
      login_as(@user2, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to have_selector('.comments-section', visible: true)
      expect(page).to have_content('A public practice')
      expect(page).to have_css('.commontator')
    end

    it 'Should allow a user to edit their existing comment' do
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
      find("#commontator-comment-1-edit").click
      fill_in('commontator-comment-1-edit-body', with: 'This is a test.')
      within(:css, '.comment') do
        click_button('Post')
      end
      expect(page).to have_content('edited')
    end

    it 'Should allow a user to delete their existing comment' do
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
      find("#commontator-comment-1-delete").click
      page.accept_alert
      expect(page).to have_selector('.comments-section', visible: true)
      expect(page).to have_content('deleted')
    end

    it 'Should allow a user to reply to an existing comment' do
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
      visit practice_path(@practice)
      click_link('Reply')
      fill_in('commontator-comment-1-reply', with: 'Hey, how are you?')
      click_button('reply')
      expect(page).to have_content('Hide 1 reply')
      expect(page).to have_content('2 COMMENTS:')
    end

    it 'Should display the verified implementer tag if the user selects the "I am currently adopting this practice" radio button' do
      fill_in('comment[body]', with: 'Hello world')
      find('label', text: 'I am currently adopting this practice').click
      click_button('commit')
      visit practice_path(@practice)
      expect(page).to have_selector('.comments-section', visible: true)
      expect(page).to have_content('PRACTICE ADOPTER')
    end

    it 'Should not display the verified implementer tag if the user selects the "Other" radio button' do
      fill_in('comment[body]', with: 'Hello world')
      find('label', text: 'Other').click
      click_button('commit')
      visit practice_path(@practice)
      expect(page).to have_selector('.comments-section', visible: true)
      expect(page).to_not have_content('PRACTICE ADOPTER')
    end


    it 'Should show the amount of likes each comment or reply has' do
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
      expect(page).to have_selector('.comments-section', visible: true)
      logout(@user2)
      visit practice_path(@practice)
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to have_selector('.comments-section', visible: true)
      find(".like").click
      expect(page).to have_css('.comment-1-1-vote')
    end

    it 'Allow the user to view the profile of a commentator if they click on their name next to the comment' do
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
      expect(page).to have_selector('#submit-comment', visible: true)
      click_link('Momo H')
      expect(page).to have_content('Profile')
      expect(page).to have_content('momo.hinamori@va.gov')
    end

    describe 'comment mailer' do
      it 'if the practice user is not the comment creator and the practice user\'s email is the same as the practice\'s support network email, it should send an email to the practice user' do
        @practice.update(support_network_email: @user1.email)
        expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(@user1.email)
      end

      it 'if the practice user\'s email is not the same as the practice\'s support network email and neither is the comment creator, it should send an email to both the practice user and the support network email' do
        expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(2)
        expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(@user1.email)
        expect(ActionMailer::Base.deliveries.last.bcc.last).to eq(@practice.support_network_email)
      end

      it 'if the practice user is the creator of a comment, it should not send an email to the practice user' do
        @practice.update(user: @user2)
        expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.bcc.first).to_not eq(@user2.email)
        expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(@practice.support_network_email)
      end

      it 'if a user exists with the an email address that matches the practice\'s support network email and that user is the comment creator, it should not send an email to the support network email address' do
        logout(@user2)
        login_as(@user3, :scope => :user, :run_callbacks => false)
        visit practice_path(@practice)
        expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.bcc.first).to_not eq(@user3.email)
        expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(@user1.email)
      end
    end
  end

  describe 'Reporting a comment' do
    before do
      set_data
      login_as(@user2, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to have_content(@practice.name)
      expect(page).to have_css('.commontator')
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
    end

    it 'should display the report abuse modal if the user clicks on the flag icon' do
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      find(".report-abuse-container").click
      expect(page).to have_content('Report a comment')
      expect(page).to have_css('.report-abuse-submit')
    end

    it 'should hide the report abuse modal if the user clicks the cancel button' do
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      find(".report-abuse-container").click
      expect(page).to have_content('Report a comment')
      expect(page).to have_css('.report-abuse-cancel')

      find(".report-abuse-cancel").click
      page.accept_alert
      expect(page).to_not have_content('Report a comment')
    end

    it 'should show a success banner after the user successfully reports a comment' do
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      find(".report-abuse-container").click
      expect(page).to have_content('Report a comment')
      expect(page).to have_css('.report-abuse-cancel')

      find(".report-abuse-submit").click
      page.accept_alert
      expect(page).to have_selector('.usa-alert', visible: true)
      expect(page).to have_content('Comment has been reported and will be reviewed shortly')
    end
  end

  describe 'Email' do
    before do
      set_data
    end

    it 'should send an email to the main email address and include any cc email addresses' do
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to have_link(href: 'mailto:testp13423041@va.gov?cc=testp13423041%40va.gov')
    end
  end

  def create_comment
    fill_in('comment[body]', with: 'This is a test comment')
    click_button('commit')
  end
end
