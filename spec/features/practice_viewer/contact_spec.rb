require 'rails_helper'
require 'spec_helper'

describe 'Contact section', type: :feature, js: true do
  let!(:user1) { create(:user, email: 'hisagi.shuhei@va.gov', first_name: 'Shuhei', last_name: 'Hisagi', confirmed_at: Time.now, accepted_terms: true) }
  let!(:user2) { create(:user, email: 'momo.hinamori@va.gov', first_name: 'Momo', last_name: 'Hinamori', confirmed_at: Time.now, accepted_terms: true) }
  let!(:user3) { create(:user, email: 'testp13423041@va.gov', first_name: 'Test', last_name: 'Account', confirmed_at: Time.now, accepted_terms: true) }
  let!(:practice) { create(:practice, name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: user3.email, user: user1) }
  let!(:practice_partner) { create(:practice_partner, name: 'Diffusion of Excellence') }
  let!(:practice_email) { create(:practice_email, practice: practice, address: '2ndpracticeemail@va.gov') }

  describe 'Authorization' do
    it 'Should allow authenticated users to view comments' do
      # Login as an authenticated user and visit the practice page
      login_as(user1, :scope => :user, :run_callbacks => false)
      visit practice_path(practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(practice.name)
      expect(page).to have_current_path(practice_path(practice))
      expect(page).to have_css('.commontator')
    end

    it 'Should allow users to add role for post comments' do
      # Login as an authenticated user, visit the practice page
      login_as(user2, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
      visit practice_path(practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(practice.name)
      expect(page).to have_content("Other")
      expect(page).to have_content('I am currently adopting this innovation')
      expect(page).to have_content('I am a member of this innovation team')
    end

    it 'Should not allow unauthenticated users to post comments' do
      # make the practice public, so the user is not redirected
      practice.update(is_public: true)
      visit practice_path(practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(practice.name)
      expect(page).to have_current_path(practice_path(practice))
      expect(page).to have_content('Comments and replies are disabled for retired innovations and non-VA users.')
      expect(page).to_not have_selector('.new-comment')
    end
  end

  describe 'Commenting flow' do
    before do
      login_as(user2, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
      visit practice_path(practice)
    end
    
    it 'should be on the correct page' do
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
      visit practice_path(practice)
      click_link('Reply')
      fill_in('commontator-comment-1-reply', with: 'Hey, how are you?')
      click_button('reply')
      expect(page).to have_content('Hide 1 reply')
      expect(page).to have_content('2 COMMENTS:')
    end

    it 'Should display the verified implementer tag if the user selects the "I am currently adopting this innovation" radio button' do
      fill_in('comment[body]', with: 'Hello world')
      find('label', text: 'I am currently adopting this innovation').click
      click_button('commit')
      visit practice_path(practice)
      expect(page).to have_selector('.comments-section', visible: true)
      expect(page).to have_content('INNOVATION ADOPTER')
    end

    it 'Should not display the verified implementer tag if the user selects the "Other" radio button' do
      fill_in('comment[body]', with: 'Hello world')
      find('label', text: 'Other').click
      click_button('commit')
      visit practice_path(practice)
      expect(page).to have_selector('.comments-section', visible: true)
      expect(page).to_not have_content('INNOVATION ADOPTER')
    end


    it 'Should show the amount of likes each comment or reply has' do
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
      expect(page).to have_selector('.comments-section', visible: true)
      logout
      visit practice_path(practice)
      login_as(user1, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
      visit practice_path(practice)
      expect(page).to have_selector('.comments-section', visible: true)
      find(".like").click
      expect(page).to have_css('.comment-1-1-vote')
    end

    describe 'comment mailer' do
      context 'when the practice user differs from the comment creator' do
        context 'and the user email matches the support network email' do
          it 'sends an email to the practice user and secondary email' do
            practice.update(support_network_email: user1.email)
            expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
            expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(2)
            expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(practice_email.address)
            expect(ActionMailer::Base.deliveries.last.bcc.last).to eq(user1.email)
          end
        end

        context 'and the practice user email does not match the support network email' do
          context 'and neither is the comment creator' do
            it 'it should send an email to the practice user, the support network email, and secondary email' do
              expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
              expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(3)
              expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(practice_email.address)
              expect(ActionMailer::Base.deliveries.last.bcc.second).to eq(practice.support_network_email)
              expect(ActionMailer::Base.deliveries.last.bcc.last).to eq(user1.email)
            end
          end
        end
      end

      it 'if the practice user is the creator of a comment, it should not send an email to the practice user' do
        practice.update(user: user2)
        expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(2)
        expect(ActionMailer::Base.deliveries.last.bcc).to_not include(user2.email)
        expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(practice_email.address)
        expect(ActionMailer::Base.deliveries.last.bcc.last).to eq(practice.support_network_email)
      end

      context "if the comment creator's email matches the practice's support network email" do
        it 'it should not send an email to the support network email address' do
          logout
          login_as(user3, :scope => :user, :run_callbacks => false)
          page.set_rack_session(:user_type => 'ntlm')
          visit practice_path(practice)
          expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)

          expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(2)
          expect(ActionMailer::Base.deliveries.last.bcc).to_not include(user3.email)
          expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(practice_email.address)
          expect(ActionMailer::Base.deliveries.last.bcc.last).to eq(user1.email)
        end
      end

      context 'if there are more than one `practice_emails` belonging to the practice' do
        it 'includes each in comment notification email' do
          practice_email2 = create(:practice_email, practice: practice)
          expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
          expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(4)
          expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(practice_email.address)
          expect(ActionMailer::Base.deliveries.last.bcc.second).to eq(practice_email2.address)
          expect(ActionMailer::Base.deliveries.last.bcc.third).to eq(practice.support_network_email)
          expect(ActionMailer::Base.deliveries.last.bcc.last).to eq(user1.email)
        end
      end

      context "if the comment creator's email is one of the practice's `practice_emails`" do
        it 'it is not included in the comment notification email' do
          practice_email.update!(address: user2.email)
          expect { create_comment }.to change { ActionMailer::Base.deliveries.count }.by(1)

          expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(2)
          expect(ActionMailer::Base.deliveries.last.bcc).to_not include(practice_email.address)
          expect(ActionMailer::Base.deliveries.last.bcc.first).to eq(practice.support_network_email)
          expect(ActionMailer::Base.deliveries.last.bcc.last).to eq(user1.email)
        end
      end
    end
  end

  describe 'Reporting a comment' do
    before do
      login_as(user2, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
      visit practice_path(practice)
      fill_in('comment[body]', with: 'Hello world')
      click_button('commit')
    end

    it 'should display the report abuse modal if the user clicks on the flag icon' do
      login_as(user1, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
      visit practice_path(practice)
      find(".report-abuse-container").click
      expect(page).to have_content('Report a comment')
      expect(page).to have_css('.report-abuse-submit')
    end

    it 'should hide the report abuse modal if the user clicks the cancel button' do
      login_as(user1, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
      visit practice_path(practice)
      find(".report-abuse-container").click
      expect(page).to have_content('Report a comment')
      expect(page).to have_css('.report-abuse-cancel')

      find(".report-abuse-cancel").click
      page.accept_alert
      expect(page).to_not have_content('Report a comment')
    end

    it 'should show a success banner after the user successfully reports a comment' do
      login_as(user1, :scope => :user, :run_callbacks => false)
      page.set_rack_session(:user_type => 'ntlm')
      visit practice_path(practice)
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
    it 'should send an email to the main email address and include any cc email addresses' do
      login_as(user1, :scope => :user, :run_callbacks => false)
      visit practice_path(practice)
      expect(page).to have_link(href: 'mailto:testp13423041@va.gov?cc=2ndpracticeemail%40va.gov')
    end
  end

  def create_comment
    fill_in('comment[body]', with: 'This is a test comment')
    click_button('commit')
  end
end