require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: false, user: @admin)
    @practice2 = Practice.create!(name: 'Another public practice', tagline: 'practice_tagline', summary: 'practice summary', slug: 'another-public-practice', date_initiated: '10/12/2019', initiating_facility: 'practice initiating facility', initiating_facility_type: 3, approved: true, published: false, user: @admin)
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @admin.add_role(User::USER_ROLES[0].to_sym)
    Category.create!(name: 'Pulmonary Care')
    Category.create!(name: 'Other')
    visn_1 = Visn.create!(name: 'VISN 1', number: 2)
    VaFacility.create!(
      visn: visn_1,
      station_number: "402GA",
      official_station_name: "Caribou VA Clinic",
      common_name: "Caribou",
      latitude: "44.2802701",
      longitude: "-69.70413586",
      street_address_state: "ME"
    )
    visn_7 = Visn.create!(id: 6, name: "VA Southeast Network", number: 7)

    VaFacility.create!(visn: visn_7, station_number: "521", official_station_name: "Birmingham VA Medical Center", common_name: "Birmingham-Alabama", street_address_state: "AL")
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
      within(all('.practice-editor-origin-li').last) do
        find('.usa-combo-box__input').click
        find('.usa-combo-box__input').set('Birmingham VA')
        all('.usa-combo-box__list-option').first.click
      end
    end

    def set_initiating_visn
      find('#initiating_facility_type_visn').sibling('label').click
      select('VISN-1', :from => 'editor_visn_select')
    end

    def set_adoption
      find('#add_adoption_button').click
      find("label[for*='status_completed']").click
      find('#editor_facility_select').click
      find("#editor_facility_select--list--option-0").click
      find('#adoption_form_submit').click
    end

    def set_overview_required_fields
      fill_in('practice_overview_problem', with: 'Practice overview problem statement')
      fill_in('practice_overview_solution', with: 'Practice overview solution statement')
      fill_in('practice_overview_results', with: 'Practice overview results statement')
    end

    it 'should display an error modal only when missing required fields exists' do
      @publish_button.click
      expect(page).to have_selector(".dm-publication-validation--alert", visible: true)
      expect(page).to have_content('Cannot publish yet')
      expect(page).to have_content('You can save your work as a draft at any time, but these sections need to be completed before publishing:')
      expect(page).to have_content('Introduction')
      expect(page).to have_content('Tagline')
      expect(page).to have_content('Date created')
      expect(page).to have_content('Innovation origin')
      expect(page).to have_content('Summary')
      expect(page).to have_content('Overview')
      expect(page).to have_content('Problem statement')
      expect(page).to have_content('Solution statement')
      expect(page).to have_content('Results statement')
      expect(page).to have_content('Adoptions')
      expect(page).to have_content('At least one adoption')
      expect(page).to have_content('Contact')
      expect(page).to have_content('Email')
      set_pr_required_fields
      set_initiating_fac
      @publish_button.click
      expect(page).to have_selector(".dm-publication-validation--alert", visible: true)
      expect(page).to have_content('Cannot publish yet')
      expect(page).to have_content('You can save your work as a draft at any time, but these sections need to be completed before publishing:')
      expect(page).to have_content('Date created')
      expect(page).to have_content('Innovation origin')
      expect(page).to have_content('Summary')
      expect(page).to have_content('At least one adoption')
      expect(page).to have_content('Email')

      visit practice_adoptions_path(@practice)
      set_adoption
      @publish_button.click
      page.has_css?('.dm-publication-validation--alert')
      expect(page).to have_no_content('At least one adoption')
      expect(page).to have_content('Email')
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
      expect(page).to_not have_link('Publish innovation')

      visit practice_path(@practice2)
      expect(page).to have_content('practice summary')
      expect(page).to have_content('Another public practice')
    end
  end
end
