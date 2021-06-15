require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    Rake::Task['visns:create_visns_and_transfer_data'].execute
    Rake::Task['va_facilities:create_va_facilities_and_transfer_data'].execute

    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: false, user: @admin)
    @practice2 = Practice.create!(name: 'Another public practice', tagline: 'practice_tagline', summary: 'practice summary', slug: 'another-public-practice', date_initiated: '10/12/2019', initiating_facility: 'practice initiating facility', initiating_facility_type: 3, approved: true, published: false, user: @admin)
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @admin.add_role(User::USER_ROLES[0].to_sym)
    Category.create!(name: 'Pulmonary Care')
    Category.create!(name: 'Other')
  end

  describe 'Publish practice flow' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_introduction_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      @save_button = find('#practice-editor-save-button')
      @publish_button = find('#publish-practice-button')
    end

    def set_pr_required_fields
      fill_in('Summary', with: 'practice summary')
      select('October', :from => 'editor_date_initiated_month')
      fill_in('Year', with: '1970')
    end

    def set_initiating_fac
      find('#initiating_facility_type_facility').sibling('label').click
      last_fac_field = find_all('.practice-editor-origin-facility-li').last
      last_fac_state_select = last_fac_field.find('select[id*="editor_state_select"]')
      last_fac_fac_select = last_fac_field.find('select[id*="facility_id"]')
      select('Alabama', from: last_fac_state_select[:name])
      select('Birmingham VA Medical Center (Birmingham-Alabama)', from: last_fac_fac_select[:name])
    end

    def set_initiating_visn
      find('#initiating_facility_type_visn').sibling('label').click
      select('VISN-1', :from => 'editor_visn_select')
    end

    def set_adoption
      find('#add_adoption_button').click
      find('label[for="status_in_progress"').click
      select('Alaska', :from => 'editor_state_select')
      select('Anchorage VA Medical Center', :from => 'editor_facility_select')
      find('#adoption_form_submit').click
    end

    def set_overview_required_fields
      fill_in('practice_overview_problem', with: 'Practice overview problem statement')
      fill_in('practice_overview_solution', with: 'Practice overview solution statement')
      fill_in('practice_overview_results', with: 'Practice overview results statement')
    end

    it 'should display an error modal only when missing required fields exists' do
      @publish_button.click
      page.has_css?('.publication-modal-body')
      expect(page).to have_content('Cannot publish yet')
      expect(page).to have_content('This is what you need to do before publishing your practice to the Diffusion Marketplace')
      expect(page).to have_content('You must include a tagline for your practice')
      expect(page).to have_content('You must include the initiation date for your practice')
      expect(page).to have_content('You must include the initiating facility for your practice')
      expect(page).to have_content('You must include a practice summary')
      expect(page).to have_content('You must include at least one adoption')
      expect(page).to have_content('You must include a support network email')
      expect(page).to have_content('You must include a problem statement for your practice')
      expect(page).to have_content('You must include a solution statement for your practice')
      expect(page).to have_content('You must include a results statement for your practice')
      find('.back-to-editor-button').click
      set_pr_required_fields
      set_initiating_fac
      @publish_button.click
      page.has_css?('.publication-modal-body')
      expect(page).to have_content('Cannot publish yet')
      expect(page).to have_content('This is what you need to do before publishing your practice to the Diffusion Marketplace')
      expect(page).to have_no_content('You must include the initiation date for your practice')
      expect(page).to have_no_content('You must include the initiating facility for your practice')
      expect(page).to have_no_content('You must include a practice summary')
      expect(page).to have_content('You must include at least one adoption')
      expect(page).to have_content('You must include a support network email')

      visit practice_adoptions_path(@practice)
      set_adoption
      @publish_button.click
      page.has_css?('.publication-modal-body')
      expect(page).to have_no_content('You must include at least one adoption')
      expect(page).to have_content('You must include a support network email')
    end

    it 'Should save and publish the practice if all required fields are met' do
      # set contact email
      visit practice_contact_path(@practice2)
      email = 'test@email.com'
      fill_in('Main email address', with: email)
      @save_button.click
      expect(page).to have_field('Main email address', with: email)

      # set adoption
      visit practice_adoptions_path(@practice2)
      set_adoption

      # set required fields in introduction page
      visit practice_introduction_path(@practice2)
      set_pr_required_fields

      #set required fields in overview section
      visit practice_overview_path(@practice2)
      set_overview_required_fields


      @publish_button.click
      expect(page).to have_no_content('Cannot publish yet')
      expect(page).to have_content("#{@practice2.name} has been successfully published to the Diffusion Marketplace")
      # Publish button should be gone if the practice has been published
      expect(page).to_not have_link('Publish practice')

      visit practice_path(@practice2)
      expect(page).to have_content('practice summary')
      expect(page).to have_content('Another public practice')
    end
  end
end
