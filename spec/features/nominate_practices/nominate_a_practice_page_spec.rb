require 'rails_helper'

describe 'Nominate a practice page', type: :feature do
  context 'VA user' do
    before do
      user = User.create!(email: 'admin-dmva@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      login_as(user, :scope => :user, :run_callbacks => false)
      visit '/nominate-an-innovation'
    end

    it 'should be there' do
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('Nominate an innovation')
      expect(page).to have_content('VA staff and collaborators are welcome to nominate active innovations for consideration on the Diffusion Marketplace using the form below.')
    end

    it 'should allow the user to send an email to the DM team about nominating an innovation' do
      fill_in('Your email address', with: 'test@test.com')
      fill_in('Subject line', with: 'Test subject')
      # all fields should be required
      click_button('Send message')
      message = find('#message').native.attribute('validationMessage')
      expect(message).to eq('Please fill out this field.')
      fill_in('Your message Please include information about where your innovation is being implemented.', with: 'This is a test message')
      # make sure the mailer count increases by 1
      expect { click_button('Send message') }.to change { ActionMailer::Base.deliveries.count }.by(1)
      # make sure the mailer content matches what the users sent
      expect(ActionMailer::Base.deliveries.last.from.first).to eq('test@test.com')
      expect(ActionMailer::Base.deliveries.last.subject).to eq('(Nominate) Test subject')
      expect(page).to have_content('Message sent. The Diffusion Marketplace team will review your nomination.')
    end

    it 'should log and redirect user to homepage if phone field is populated' do
      fill_in('Your email address', with: 'test@test.com')
      fill_in('Subject line', with: 'Test subject')
      # all fields should be required
      click_button('Send message')
      message = find('#message').native.attribute('validationMessage')
      expect(message).to eq('Please fill out this field.')
      fill_in('Your message Please include information about where your innovation is being implemented.', with: 'This is a test message')
      fill_in('phone', with: 'this is spam')
      # make sure the FormSpam records increase by 1
      expect { click_button('Send message') }.to change(FormSpam, :count).by(1)
      # make sure user is redirected to home page.
      expect(page).to have_current_path(root_path)
    end

    it 'should redirect the user to /nominate-an-innovation if they try to visit the old /nominate-a-practice URL' do
      visit '/nominate-a-practice'
      expect(page).to have_current_path(nominate_an_innovation_path)
    end
  end
end
