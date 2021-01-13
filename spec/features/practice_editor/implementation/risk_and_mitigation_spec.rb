require 'rails_helper'

describe 'Practice', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), initiating_facility_type: 'facility')
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Implementation page - Risk and mitigation' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
    end

    def fill_in_core_people_field
      fill_in('Resource', with: 'A practice person')
    end

    def visit_pr_edit
      visit practice_implementation_path(@practice)
    end

    def add_another
      find('.add-risk-mitigation-link').click
    end

    def save_pr
      find('#practice-editor-save-button').click
    end

    def set_risk(index, value)
      find_all('.risk-description-textarea')[index].set(value)
    end

    def set_miti(index, value)
      find_all('.mitigation-description-textarea')[index].set(value)
    end

    it 'should allow the user to update the risks and mitigations for the practice' do
      # navigate to the PE Implementation form
      visit_pr_edit
      expect(page).to have_content('Risk and mitigation')
      expect(page).to have_content('Share the difficulties and risks a facility may face during implementation.')
      expect(page).to have_css('#dm-add-button-risk-mitigation')
      expect(page).to have_no_css('#dm-add-link-risk-mitigation')

      fill_in_core_people_field

      # create one risk and mitigation and save
      add_another
      expect(page).to have_content('Description of the risk')
      expect(page).to have_content('Corresponding mitigation')
      expect(page).to have_content('Add another')
      expect(page).to have_content('Delete entry')
      set_risk(0, 'first risk')
      set_miti(0, 'first mitigation')
      save_pr

      # check risk and mitigation in practice view
      visit '/practices/a-public-practice'
      within(:css, '#implementation') do
        expect(page).to have_content('Risks and mitigations')
        expect(page).to have_content('first risk')
        expect(page).to have_content('first mitigation')
      end

      # edit risk and mitigation
      visit_pr_edit
      expect(page).to have_content('Description of the risk')
      set_risk(0, 'first edited risk')
      set_miti(0, 'first edited mitigation')
      save_pr

      # check risk and mitigation in practice view
      visit '/practices/a-public-practice'
      within(:css, '#implementation') do
        expect(page).to have_content('first edited risk')
        expect(page).to have_content('first edited mitigation')
      end
      # add another one plus others with empty fields
      visit_pr_edit
      add_another
      set_risk(1, 'risk should not be saved')
      add_another
      set_miti(2, 'mitigation should not be saved')
      add_another
      add_another
      set_risk(4, 'second risk')
      set_miti(4, 'second mitigation')
      save_pr

      # check risk and mitigation in practice view
      visit '/practices/a-public-practice'
      within(:css, '#implementation') do
        expect(page).to have_content('first edited risk')
        expect(page).to have_content('first edited mitigation')
        expect(page).to have_content('second risk')
        expect(page).to have_content('second mitigation')
        expect(page).to have_no_content('risk should not be saved')
        expect(page).to have_no_content('mitigation should not be saved')
      end

      # remove risk and mitigation
      visit_pr_edit
      find_all('.risk-mitigation-trash')[1].click
      save_pr

      # check risk and mitigation in practice view
      visit '/practices/a-public-practice'
      within(:css, '#implementation') do
        expect(page).to have_content('first edited risk')
        expect(page).to have_content('first edited mitigation')
        expect(page).to have_no_content('second risk')
        expect(page).to have_no_content('second mitigation')
      end
    end
  end
end
