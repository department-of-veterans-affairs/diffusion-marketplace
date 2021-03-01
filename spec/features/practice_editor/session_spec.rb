require 'rails_helper'
describe 'Practice Editor', type: :feature, js: true do
  describe 'Editors Page' do
    before do
      @user = User.create!(email: 'satoru.gojo@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      @admin = User.create!(email: 'yuji.itadori@va.gov', first_name: 'Yuji', last_name: 'Itadori', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
      @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    def login_and_visit_editors(user)
      login_as(user, :scope => :user, :run_callbacks => false)
      visit practice_editors_path(@practice)
    end




    it 'should not allow a user to edit practice if practice is locked for editing' do
      debugger
      login_and_visit_editors(@admin)
      # fill_in_email_field(@user.email)
      # add_editor
      logout(@admin)
      login_and_visit_editors(@user)
      expect(page).to have_content('You cannot edit this practice since it is currently being edited by Yuji Itadori')
    end
    def logout(*scopes)
      Warden.on_next_request do |proxy|
        proxy.logout(*scopes)
      end
    end

  end
end