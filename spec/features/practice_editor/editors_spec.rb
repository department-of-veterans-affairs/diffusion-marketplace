require 'rails_helper'

describe 'Practice Editor', type: :feature, js: true do
  describe 'Editors Page' do
    before do
      @user = User.create!(email: 'satoru.gojo@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      @admin = User.create!(email: 'yuji.itadori@va.gov', first_name: 'Yuji', last_name: 'Itadori', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
      @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    def save_practice
      click_on 'Save'
    end

    def add_editor
      click_on 'Send invite'
    end

    def fill_in_email_field(email)
      fill_in('E-mail the people who can help you edit this practice page. Only @va.gov emails are allowed.', with: email)
    end

    def delete_practice_editor(editor_id)
      find("#delete-practice-editor-#{editor_id}").click
      page.accept_alert
    end

    def login_and_visit_editors(user)
      login_as(user, :scope => :user, :run_callbacks => false)
      visit practice_editors_path(@practice)
    end

    it 'should be there' do
      login_and_visit_editors(@admin)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('Editors')
      expect(page).to have_content('E-mail the people who can help you edit this practice page. Only @va.gov emails are allowed.')
    end

    describe 'Authorization' do
      it 'should not allow a user to reach the Editors page unless they are at least one of the following: practice owner, admin, or practice editor' do
        login_and_visit_editors(@user)
        expect(page).to have_content('You are not authorized to view this content.')
      end

      it 'should allow a user to reach the Editors page if they are at least one of the following: practice owner, admin, or practice editor' do
        PracticeEditor.create!(practice: @practice, user: @user)
        login_and_visit_editors(@user)
        expect(page).to have_content('Editors')
        expect(page).to have_content('Add editors')
      end
    end

    describe 'Adding editors' do
      it 'should not allow a user to add an editor that already exists for the practice' do
        login_and_visit_editors(@admin)
        fill_in_email_field('yuji.itadori@va.gov')
        add_editor
        expect(page).to have_content('There was an error. A user with the email "yuji.itadori@va.gov" is already an editor for this practice.')
      end

      it 'should not allow a user to add an editor if they hit the save button with an empty email field' do
        login_and_visit_editors(@admin)
        save_practice
        expect(page).to have_content('There was an error. Email field cannot be blank.')
      end

      it 'should not allow a user to add an editor with an email that doesn\'t end with @va.gov' do
        login_and_visit_editors(@admin)
        fill_in_email_field('yuji.itadori@test.com')
        add_editor
        editor_email_message = page.find('.editor-input').native.attribute('validationMessage')
        expect(editor_email_message).to eq('Please match the requested format.')
      end

      it 'should allow a user to add editors to the practice if all requirements are met' do
        login_and_visit_editors(@admin)
        fill_in_email_field('test@va.gov')
        add_editor
        expect(page).to have_content('Editor was added to the list.')
        expect(page).to have_content('yuji.itadori@va.gov')
        expect(page).to have_content('Yuji Itadori')
        expect(page).to have_content('Added to the team')
      end

      it 'should send an email to each newly added practice editor' do
        login_and_visit_editors(@admin)
        fill_in_email_field('test@va.gov')
        # make sure the mailer count increases by 1
        expect { add_editor }.to change { ActionMailer::Base.deliveries.count }.by(1)
        # make sure the mailer subject is for a practice editor that's not also the practice owner
        expect(ActionMailer::Base.deliveries.last.subject).to eq('You are invited to edit the A public practice Diffusion Marketplace Page!')
      end
    end

    describe 'Deleting editors' do
      it 'should not allow a user to delete an editor if that editor is the last one for the practice' do
        login_and_visit_editors(@admin)
        delete_practice_editor(1)
        expect(page).to have_content('There was an error. At least one editor is required.')
      end

      it 'should allow a user to delete an editor if they aren\'t the last editor' do
        login_and_visit_editors(@admin)
        fill_in_email_field(@user.email)
        add_editor
        delete_practice_editor(1)
        expect(page).to have_content('Editor was removed from the list.')
      end

      describe 'edge cases' do
        it 'should no longer allow a user to edit the practice if they choose to delete themselves AND they are not the practice owner or admin' do
          login_and_visit_editors(@admin)
          fill_in_email_field(@user.email)
          add_editor
          logout(@admin)
          login_and_visit_editors(@user)
          delete_practice_editor(2)
          expect(page).to have_content('You are not authorized to view this content.')
        end

        it 'should allow a user to delete the practice editor associated with the practice owner' do
          login_and_visit_editors(@admin)
          fill_in_email_field(@user.email)
          add_editor
          logout(@admin)
          login_and_visit_editors(@user)
          expect(page).to have_content(@admin.email)
          delete_practice_editor(1)
          expect(page).to have_content('Editor was removed from the list.')
          expect(page).to_not have_content(@admin.email)
        end
      end
    end
  end
end