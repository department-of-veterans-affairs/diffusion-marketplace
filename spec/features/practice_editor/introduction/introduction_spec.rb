require 'rails_helper'

describe 'Practice editor - introduction', type: :feature, js: true do
  before do
    Visn.create!(id: 1, name: "VA New England Healthcare System", number: 1)
    visn_7 = Visn.create!(id: 6, name: "VA Southeast Network", number: 7)
    visn_21 = Visn.create!(id: 16, name: "Sierra Pacific Network", number: 21)

    facility_1 = VaFacility.create!(visn: visn_21, station_number: "640A0", official_station_name: "Palo Alto VA Medical Center-Menlo Park", common_name: "Palo Alto-Menlo Park", street_address_state: "CA")
    VaFacility.create!(visn: visn_7, station_number: "521", official_station_name: "Birmingham VA Medical Center", common_name: "Birmingham-Alabama", street_address_state: "AL")

    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    img_path = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    @practice = Practice.create!(name: 'A public maximum practice', tagline: 'A public tagline', short_name: 'LALA', slug: 'a-public-max-practice', approved: true, published: true, summary: 'Test summary', date_initiated: Date.new(2016, 8, 20), initiating_facility_type: 'facility', main_display_image: File.new(img_path), user: @admin)
    @pr_facility = PracticeOriginFacility.create!(practice: @practice, facility_type: 0, va_facility: facility_1)
    PracticeAward.create!(practice: @practice, name: 'QUERI Veterans Choice Act Award', created_at: Time.now)
    PracticeAward.create!(practice: @practice, name: 'Diffusion of Excellence Promising Practice', created_at: Time.now)
    @pr_partner_1 = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care, while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002', is_major: true)
    @pr_partner_2 = PracticePartner.create!(name: 'Office of Rural Health', short_name: 'ORH', description: 'Congress established the Veterans Health Administration Office of Rural Health in 2006 to conduct, coordinate, promote and disseminate research on issues that affect the nearly five million Veterans who reside in rural communities. Working through its three Veterans Rural Health Resource Centers, as well as partners from academia, state and local governments, private industry, and non-profit organizations, ORH strives to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE', is_major: true)
    @pr_partner_3 = PracticePartner.create!(name: 'Awesome Practice Partner', short_name: 'APP', description: 'Hello world')
    PracticePartnerPractice.create!(practice: @practice, practice_partner: @pr_partner_1, created_at: Time.now)
    PracticePartnerPractice.create!(practice: @practice, practice_partner: @pr_partner_2, created_at: Time.now)
    @parent_cat_1 = Category.create!(name: 'Strategic')
    @parent_cat_2 = Category.create!(name: 'Operational')
    @parent_cat_3 = Category.create!(name: 'Clinical')
    @cat_1 = Category.create!(name: 'COVID', parent_category: @parent_cat_1)
    Category.create!(name: 'Environmental Services', parent_category: @parent_cat_2)
    Category.create!(name: 'Follow-up Care', parent_category: @parent_cat_3)
    Category.create!(name: 'Pulmonary Care', parent_category: @parent_cat_3)
    Category.create!(name: 'Hidden Cat')
    @cat_2 = Category.create!(name: 'Foobar', parent_category: @parent_cat_2, is_other: true)
    CategoryPractice.create!(practice: @practice, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @practice, category: @cat_2, created_at: Time.now)

    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'on load' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit_practice_edit
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should display the content correctly' do
      expect(page).to have_content('Introduction')
      expect(page).to have_content('Introduce your innovation and provide a brief summary to people who may be unfamiliar with it.')
      expect(page).to have_content('Do not enter PII or PHI for any individual, Veteran, or patient. See our Privacy policy.')
      expect(page).to have_content('Name (required field)')
      expect(page).to have_content('Type the official name of your innovation.')
      expect(page).to have_content('Acronym')
      expect(page).to have_content('Summary (required field)')
      expect(page).to have_content('Type a short 1-3 sentence summary of your innovation’s mission to engage the audience and provide initial context.')
      expect(page).to have_content('Date created (required field)')
      expect(page).to have_content('Select the month and year this innovation was created.')
      expect(page).to have_content('Innovation origin (required field)')
      expect(page).to have_content('Select the location where this innovation originated')
      expect(page).to have_content('Awards and recognition')
      expect(page).to have_content('Partners')
      expect(page).to have_content('Type or select from the dropdown any of the following partners your innovation is associated with.')
      expect(page).to have_content('Diffusion phase')
      expect(page).to have_content('Select the diffusion phase that applies to your innovation.')
      expect(page).to have_link(href: "/innovations/#{@practice.slug}/edit/instructions")
      expect(page).to have_link(href: "/innovations/#{@practice.slug}/edit/adoptions")
      # categories
      expect(page).to have_content('Categories')
      expect(page).to have_content('Select the categories most relevant to your innovation (suggested: up to 10).')
      expect(page).to have_no_content('Hidden Cat')
      expect(page).to have_content('Clinical')
      expect(page).to have_content('Operational')
      expect(page).to have_content('Strategic')
      within(:css, '.dm-clinical-category-columns-container') do
        page.has_unchecked_field?('Follow-up Care')
        page.has_unchecked_field?('Pulmonary Care')
        page.has_unchecked_field?('All clinical')
        page.has_unchecked_field?('Other')
      end
      within(:css, '.dm-operational-category-columns-container') do
        page.has_unchecked_field?('Environmental Ser...')
        page.has_unchecked_field?('All operational')
        page.has_checked_field?('Other')
        expect(page).to have_content('Add another')
        expect(page).to have_no_content('Delete entry')
        expect(page).to have_content('Category name')
        expect(find_field('Category name', visible: true).value).to eq('Foobar')
      end
      within(:css, '.dm-strategic-category-columns-container') do
        page.has_checked_field?('COVID')
        page.has_checked_field?('All strategic')
        page.has_unchecked_field?('Other')
      end
      find('.parent-category-modal').click
      expect(page).to have_selector(".usa-modal__content", visible: true)
      expect(page).to have_content('Innovations related to patient care.')
      expect(page).to have_content('Innovations related to VA administrative and logistical functions.')
      expect(page).to have_content('Innovations that support initiatives identified by VA leadership.')
    end
  end

  describe 'editing a practice' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit_practice_edit
    end

    it 'should allow changing name, acronym, summary' do
      expect(page).to have_field('Name', with: @practice.name)
      expect(page).to have_field('Acronym', with: @practice.short_name)
      expect(page).to have_field('Summary', with: @practice.summary)
      # add whitespace to practice name
      fill_in('Name (required field)', with: '   Edited practice ')
      fill_in('Acronym', with: 'YOLO')
      fill_in('Summary', with: 'Updated summary')
      click_save
      # make sure white space is trimmed from practice name
      expect(page).to have_field('Name', with: 'Edited practice')

      visit_practice_show
      expect(page).to have_content('Edited practice')
      expect(page).to have_content('YOLO')
      expect(page).to have_content('Updated summary')
      expect(page).to have_no_content(@practice.name)
      expect(page).to have_no_content(@practice.short_name)
      expect(page).to have_no_content(@practice.summary)
    end

    it 'should allow changing date created' do
      expect(page).to have_field('Month', with: '8')
      expect(page).to have_field('Year', with: '2016')
      # Make sure client-side validation is working
      select('October', :from => 'editor_date_initiated_month')
      fill_in('Year', with: '1969')
      click_save
      year_created_message = page.find('#editor_date_initiated_year').native.attribute('validationMessage')
      expect(year_created_message).to eq('Please select a value that is no less than 1970.')
      fill_in('Year', with: '1970')
      click_save
      visit_practice_show
      expect(page).to have_content('October 1970')
      expect(page).to have_no_content('August 2013')
    end

    context 'practice origin' do
      it 'should allow changing facilities' do
        expect(find(:css, '#initiating_facility_type_facility').selected?).to eq(true)
        expect(find(:css, '#initiating_facility_type_visn').selected?).to eq(false)
        expect(find(:css, '#initiating_facility_type_department').selected?).to eq(false)
        expect(find(:css, '#initiating_facility_type_other').selected?).to eq(false)
        expect(find(:css, 'select#editor_state_select_1').value).to eq('CA')
        expect(find(:css, 'select#practice_practice_origin_facilities_attributes_0_va_facility_id').value).to eq(@pr_facility.va_facility_id.to_s)

        # add another facility
        find('.dm-add-practice-originating-facilities-link').click
        last_fac_field = find_all('.practice-editor-origin-facility-li').last
        last_fac_state_select = last_fac_field.find('select[id*="editor_state_select"]')
        last_fac_fac_select = last_fac_field.find('select[id*="va_facility_id"]')
        select('Alabama', from: last_fac_state_select[:name])
        select('Birmingham VA Medical Center (Birmingham-Alabama)', from: last_fac_fac_select[:name])
        # delete first facility
        first_fac_field = find_all('.practice-editor-origin-facility-li').first
        first_fac_field.find('.dm-origin-trash').click
        click_save
        visit_practice_show
        expect(page).to have_content('Birmingham VA Medical Center (Birmingham-Alabama)')
        expect(page).to have_no_content('Palo Alto VA Medical Center-Menlo Park')

        # set VISN
        visit_practice_edit
        click_origin_type('initiating_facility_type_visn')
        select('VISN-1', :from => 'editor_visn_select')
        click_save
        visit_practice_show
        expect(page).to have_no_content('Birmingham VA Medical Center (Birmingham-Alabama)')
        expect(page).to have_content('VISN-1')
        # make sure the VISN text is a link to the VISN's show page
        new_window = window_opened_by { click_link 'VISN-1' }
        within_window new_window do
          expect(page).to have_content('1: VA New England Healthcare System')
          expect(page).to have_content('This VISN has 0 facilities')
        end

        # set department
        visit_practice_edit
        click_origin_type('initiating_facility_type_department')
        select('VBA', :from => 'editor_department_select')
        select('Alabama', :from => 'editor_office_state_select')
        select('Montgomery Regional Office', :from => 'editor_office_select')
        click_save
        visit_practice_show
        expect(page).to have_no_content('VISN-1')
        expect(page).to have_content('Montgomery Regional Office')

        # set other
        visit_practice_edit
        click_origin_type('initiating_facility_type_other')
        within(:css, '#init_facility_other') do
          fill_in('Other', with: 'Xavier Institute')
        end
        click_save
        visit_practice_show
        expect(page).to have_no_content('Montgomery Regional Office')
        expect(page).to have_content('Xavier Institute')
      end

      it 'should display an error and revert changes if fields are not populated' do
        # select the VISN radio option, but do not select a VISN
        click_origin_type('initiating_facility_type_visn')
        click_save
        expect(page).to_not have_content('Innovation was successfully updated.')
        expect(page).to have_content('There was an error updating initiating facility. The innovation was not saved.')

        # now change initiating_facility_type to VISN, save, and then choose the Office radio option without choosing a facility
        click_origin_type('initiating_facility_type_visn')
        select('VISN-1', :from => 'editor_visn_select')
        click_save
        visit_practice_show
        expect(page).to have_no_content('Birmingham VA Medical Center (Birmingham-Alabama)')
        expect(page).to have_content('VISN-1')

        visit_practice_edit
        click_origin_type('initiating_facility_type_department')
        select('VBA', :from => 'editor_department_select')
        select('Alabama', :from => 'editor_office_state_select')
        click_save
        expect(page).to_not have_content('Innovation was successfully updated.')
        expect(page).to have_content('There was an error updating initiating facility. The innovation was not saved.')
      end
    end

    context 'awards and recognition' do
      it 'should allow changing awards' do
        expect(find('#practice_award_queri_veterans_choice_act_award', visible: false)).to be_checked
        expect(find('#practice_award_diffusionof_excellence_promising_practice', visible: false)).to be_checked
        expect(find('#practice_award_vha_shark_tank_winner', visible: false)).to_not be_checked
        find('#practice_award_fed_health_it_award_label').click # selects FedHealth IT Award
        find('#practice_award_other_label').click # selects other
        find('#practice_award_vha_shark_tank_winner_label').click # deselects VHA Shark Tank Winner
        expect(page).to have_content('Name of award or recognition')
        fill_in('Name of award or recognition', with: 'Amazing Award')
        click_save
        visit_practice_show
        expect(page).to have_no_content('VHA Shark Tank Winnder')
        expect(page).to have_content('QUERI Veterans Choice Act Award')
        expect(page).to have_content('Diffusion of Excellence Promising Practice')
      end
    end

    context 'partners' do
      def set_practice_partner_combo_box_val(value)
        find('.usa-combo-box__input').click
        find('.usa-combo-box__input').set(value)
        all('.usa-combo-box__list-option').first.click
      end

      it 'should allow changing partners' do
        expect(find(:css, '#practice_practice_partner_practices_attributes_0_practice_partner_id').value).to eq('Diffusion of Excellence')
        expect(find(:css, '#practice_practice_partner_practices_attributes_1_practice_partner_id').value).to eq('Office of Rural Health')
        # add another partner
        find('#link_to_add_link_practice_partner_practices').click
        within(all('.dm-practice-editor-practice-partner-li').last) do
          set_practice_partner_combo_box_val('Awesome')
        end
        # remove the Diffusion of Excellence partner
        within(all('.dm-practice-editor-practice-partner-li')[0]) do
          click_link('Delete entry')
        end
        click_save
        expect(find(:css, '#practice_practice_partner_practices_attributes_1_practice_partner_id').value).to eq(@pr_partner_3.name)
        visit_practice_show
        expect(page).to_not have_link('Diffusion of Excellence')
        expect(page).to_not have_link(@pr_partner_3.name)
        expect(page).to have_link('Office of Rural Health')
        # make sure the user can't create two of the same unsaved practice partner
        visit_practice_edit
        find('#link_to_add_link_practice_partner_practices').click
        within(all('.dm-practice-editor-practice-partner-li').last) do
          set_practice_partner_combo_box_val('Diffusion')
        end

        find('#link_to_add_link_practice_partner_practices').click
        within(all('.dm-practice-editor-practice-partner-li').last) do
          set_practice_partner_combo_box_val('Diffusion')
        end
        click_save
        expect(find(:css, '#practice_practice_partner_practices_attributes_2_practice_partner_id').value).to eq('Diffusion of Excellence')
        expect(page).to have_selector('.dm-practice-editor-practice-partner-li', count: 3)
        # make sure the user can't create a duplicate practice partner if that same practice partner is already in the list of partners
        # remove the 'Office of Rural Health' partner from the list
        within(all('.dm-practice-editor-practice-partner-li')[0]) do
          click_link('Delete entry')
        end
        # try to create a new 'Office of Rural Health' partner at the same time
        find('#link_to_add_link_practice_partner_practices').click
        within(all('.dm-practice-editor-practice-partner-li').last) do
          set_practice_partner_combo_box_val('Office')
        end
        click_save
        # make sure the first entry ('Office of Rural Health') never got destroyed and that there are still only 3 partners in the list
        expect(find(:css, '#practice_practice_partner_practices_attributes_0_practice_partner_id').value).to eq('Office of Rural Health')
        expect(page).to have_selector('.dm-practice-editor-practice-partner-li', count: 3)
      end
    end

    context 'categories' do
      it 'should allow changing categories' do
        within(:css, '.dm-strategic-category-columns-container') do
          # uncheck "All strategic" button
          find('.usa-checkbox__label[for="cat-all-strategic-input"]').click
          page.has_unchecked_field?('COVID')
          page.has_unchecked_field?('All strategic')
          page.has_unchecked_field?('Other')
          # add "Other" category
          find('.usa-checkbox__label[for="cat-other-strategic-input"]').click
          fill_in('Category name', with: 'other strategic category')
          expect(page).to have_content('Add another')
        end
        within(:css, '.dm-operational-category-columns-container') do
          # add another "Other" category
          find('.add-category-link-operational').click
          other_cat_2 = find_all('.practice-input')[1]
          other_cat_2.set 'other operational category'
          # remove the exisiting "Other" category
          find_all('.remove_nested_fields')[0].click
          # add subcategory
          find('.usa-checkbox__label[title="Environmental Services"]').click
        end
        within(:css, '.dm-clinical-category-columns-container') do
          # add categories
          find('.usa-checkbox__label[title="Pulmonary Care"]').click
          find('.usa-checkbox__label[title="Follow-up Care"]').click
          page.has_checked_field?('All clinical')
          # uncheck one category
          find('.usa-checkbox__label[title="Pulmonary Care"]').click
          page.has_unchecked_field?('All clinical')
          # check "All clinical" button
          find('.usa-checkbox__label[for="cat-all-clinical-input"]').click
          page.has_checked_field?('Pulmonary Care')
          page.has_checked_field?('Follow-up Care')
          page.has_checked_field?('All clinical')
        end
        click_save
        within(:css, '.dm-strategic-category-columns-container') do
          expect(find_field('Category name', visible: true).value).to eq('other strategic category')
          page.has_unchecked_field?('COVID')
          page.has_unchecked_field?('All strategic')
          page.has_checked_field?('Other')
        end
        within(:css, '.dm-operational-category-columns-container') do
          other_cat_ct = find_all('.practice-input').count
          expect(other_cat_ct).to eq(1)
          expect(find_field('Category name', visible: true).value).to eq('other operational category')
          page.has_checked_field?('Other')
          page.has_checked_field?('Environmental Ser...')
          find('.usa-checkbox__label[for="cat-other-operational-input"]').click
        end
        within(:css, '.dm-clinical-category-columns-container') do
          page.has_checked_field?('Pulmonary Care')
          page.has_checked_field?('Follow-up Care')
          page.has_checked_field?('All clinical')
        end
        click_save
        within(:css, '.dm-operational-category-columns-container') do
          page.has_unchecked_field?('Other')
          page.has_checked_field?('Environmental Ser...')
        end
        visit_practice_show
        expect(page).to have_no_content('COVID')
        expect(page).to have_content('ENVIRONMENTAL SERVICES')
        expect(page).to have_content('PULMONARY CARE')
        expect(page).to have_content('FOLLOW-UP CARE')
      end
    end

    context 'maturity' do
      it 'should allow the user to add or update the maturity level of a practice' do
        expect(find(:css, '#maturity_level_emerging').selected?).to eq(false)
        expect(find(:css, '#maturity_level_replicate').selected?).to eq(false)
        expect(find(:css, '#maturity_level_scale').selected?).to eq(false)

        # choose a maturity level
        click_origin_type('maturity_level_replicate')
        click_save
        expect(find(:css, '#maturity_level_replicate').selected?).to eq(true)

        # choose another maturity level
        click_origin_type('maturity_level_emerging')
        click_save
        expect(find(:css, '#maturity_level_emerging').selected?).to eq(true)
      end
    end
  end
end

def click_save
  find('#practice-editor-save-button').click
end

def visit_practice_show
  visit practice_path(@practice)
end

def visit_practice_edit
  visit practice_introduction_path(@practice)
end

def click_origin_type(elem_id)
  find("##{elem_id}").sibling('label').click
end

def click_maturity_level(elem_id)
  find("##{elem_id}").sibling('label').click
end
