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
      find('#practice-editor-save-button').click
    end

    def add_editor
      click_on 'Send invite'
    end

    def fill_in_email_field(email)
      fill_in('E-mail the people who can help you edit this practice page. Only @va.gov emails are allowed.', with: email)
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
      it 'should not allow the user to reach the Editors page unless they are at least one of the following: practice user, admin, or practice editor' do
        login_and_visit_editors(@user)
        expect(page).to have_content('You are not authorized to view this content')
      end

      it 'should allow the user to reach the Editors page if they are at least one of the following: practice user, admin, or practice editor' do
        PracticeEditor.create!(practice: @practice, user: @user, email: @user.email)
        login_and_visit_editors(@user)
        expect(page).to have_content('Editors')
        expect(page).to have_content('Add editors')
      end
    end

    describe 'Adding editors' do
      it 'should allow the user to add editors to the practice' do
        login_and_visit_editors(@admin)
        fill_in_email_field('test@va.gov')
        add_editor
        expect(page).to have_content('Editor was added to the list.')
        expect(page).to have_content('yuji.itadori@va.gov')
        expect(page).to have_content('Yuji Itadori')
        expect(page).to have_content('Added to the team')
      end

      it 'should not allow the user to add an editor that already exists for the practice' do
        login_and_visit_editors(@admin)
        fill_in_email_field('yuji.itadori@va.gov')
        add_editor
        expect(page).to have_content('There was an error. A user with the email "yuji.itadori@va.gov" is already an editor for this practice.')
      end
    end
  end
end