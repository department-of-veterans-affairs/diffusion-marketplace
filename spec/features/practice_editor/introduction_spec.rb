require 'rails_helper'

describe 'Practice editor - introduction', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    img_path = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    @practice = Practice.create!(name: 'A public maximum practice', short_name: 'LALA', slug: 'a-public-max-practice', approved: true, published: true, summary: 'Test summary', date_initiated: Date.new(2016, 8, 20), initiating_facility_type: 'facility', main_display_image: File.new(img_path))
    @pr_facility = PracticeOriginFacility.create!(practice: @practice, facility_type: 0, facility_id: '640A0')
    PracticeAward.create!(practice: @practice, name: 'QUERI Veterans Choice Act Award', created_at: Time.now)
    PracticeAward.create!(practice: @practice, name: 'Diffusion of Excellence Promising Practice', created_at: Time.now)
    @pr_partner_1 = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best practices through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care, while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @pr_partner_2 = PracticePartner.create!(name: 'Office of Rural Health', short_name: 'ORH', description: 'Congress established the Veterans Health Administration Office of Rural Health in 2006 to conduct, coordinate, promote and disseminate research on issues that affect the nearly five million Veterans who reside in rural communities. Working through its three Veterans Rural Health Resource Centers, as well as partners from academia, state and local governments, private industry, and non-profit organizations, ORH strives to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE')
    @pr_partner_3 = PracticePartner.create!({name: 'None of the above, or Unsure'})
    PracticePartnerPractice.create!(practice: @practice, practice_partner: @pr_partner_1, created_at: Time.now)
    PracticePartnerPractice.create!(practice: @practice, practice_partner: @pr_partner_2, created_at: Time.now)

    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'on load' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_introduction_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should display the content correctly' do
      expect(page).to have_content('Introduction')
      expect(page).to have_content('Introduce your practice and provide a brief summary to people who may be unfamiliar with it.')
      expect(page).to have_content('Do not enter PII or PHI for any individual, Veteran, or patient. See our Privacy policy.')
      expect(page).to have_content('Name (required field)')
      expect(page).to have_content('Type the official name of your practice.')
      expect(page).to have_content('Acronym')
      expect(page).to have_content('Summary (required field)')
      expect(page).to have_content('Type a short summary of your practice’s mission to engage the audience and provide initial context.')
      expect(page).to have_content('Date created (required field)')
      expect(page).to have_content('Select the month and year this practice was created.')
      expect(page).to have_content('Practice origin (required field)')
      expect(page).to have_content('Select the location where this practice originated')
      expect(page).to have_content('Awards and recognition')
      expect(page).to have_content('Partners')
      expect(page).to have_content('Select any of the following partners your practice is associated with.')
      expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/instructions")
      expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/adoptions")
    end
  end

  describe 'editing a practice' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_introduction_path(@practice)
    end

    it 'should allow changing name, acronym, summary' do
      expect(page).to have_field('Name', with: @practice.name)
      expect(page).to have_field('Acronym', with: @practice.short_name)
      expect(page).to have_field('Summary', with: @practice.summary)
      fill_in('Name', with: 'Edited practice')
      fill_in('Acronym', with: 'YOLO')
      fill_in('Summary', with: 'Updated summary')
      click_save
      visit_practice
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
      select('October', :from => 'editor_date_intiated_month')
      select('1970', :from => 'editor_date_intiated_year')
      click_save
      visit_practice
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
        expect(find(:css, 'select#practice_practice_origin_facilities_attributes_0_facility_id').value).to eq(@pr_facility.facility_id)

        # add another facility
        find('.add-practice-originating-facilities-link').click
        find(:xpath, "//div[@id='facility_select_form']/ul/li[last()]/div/select/option[text()='Alabama']").click
        find(:xpath, "//div[@id='facility_select_form']/ul/li[last()]/div[2]/div/select/option[text()='Birmingham VA Medical Center (Birmingham-Alabama)']").click
        # delete first facility
        find(:xpath, "//div[@id='facility_select_form']/ul/li[1]/div[2]/div[2]/a[text()='Delete Entry']").click
        click_save
        visit_practice
        expect(page).to have_content('Birmingham VA Medical Center (Birmingham-Alabama)')
        expect(page).to have_no_content('Palo Alto VA Medical Center-Menlo Park')

        # set VISN
        visit practice_introduction_path(@practice)
        find(:xpath, "//*[@id='initiating_facility_type_visn']/following-sibling::label").click
        select('VISN-1', :from => 'editor_visn_select')
        click_save
        visit_practice
        expect(page).to have_no_content('Birmingham VA Medical Center (Birmingham-Alabama)')
        expect(page).to have_content('VISN-1')

        # set department
        visit practice_introduction_path(@practice)
        find(:xpath, "//*[@id='initiating_facility_type_department']/following-sibling::label").click
        select('VBA', :from => 'editor_department_select')
        select('Alabama', :from => 'editor_office_state_select')
        select('Montgomery Regional Office', :from => 'editor_office_select')
        click_save
        visit_practice
        expect(page).to have_no_content('VISN-1')
        expect(page).to have_content('Montgomery Regional Office')

        # set other
        visit practice_introduction_path(@practice)
        find(:xpath, "//*[@id='initiating_facility_type_other']/following-sibling::label").click
        within(:css, '#init_facility_other') do
          fill_in('Other', with: 'Xavier Institute')
        end
        click_save
        visit_practice
        expect(page).to have_no_content('Montgomery Regional Office')
        expect(page).to have_content('Xavier Institute')
      end
    end

    context 'awards and recognition' do
      it 'should allow changing awards' do
        expect(page).to have_checked_field('QUERI Veterans Choice Act Award')
        expect(page).to have_checked_field('Diffusion of Excellence Promising Practice')
        expect(page).to have_unchecked_field('VHA Shark Tank Winner')
        expect(page).to have_no_content('Name of award or recognition')
        find('#practice_award_fed_health_it_award_label').click # selects FedHealth IT Award
        find('#practice_award_other_label').click # selects other
        find('#practice_award_vha_shark_tank_winner_label').click # deselects VHA Shark Tank Winner
        expect(page).to have_content('Name of award or recognition')
        fill_in('Name of award or recognition', with: 'Amazing Award')
        click_save
        visit_practice
        expect(page).to have_no_content('VHA Shark Tank Winnder')
        expect(page).to have_no_content('Other')
        expect(page).to have_content('QUERI Veterans Choice Act Award')
        expect(page).to have_content('Diffusion of Excellence Promising Practice')
      end
    end

    context 'partners' do
      it 'should allow changing partners' do
        expect(page).to have_checked_field('Diffusion of Excellence')
        expect(page).to have_checked_field('Office of Rural Health')
        expect(page).to have_unchecked_field('None of the above, or Unsure')
        find('#practice_partner_3_label').click # clicks None
        expect(page).to have_unchecked_field('Diffusion of Excellence')
        expect(page).to have_unchecked_field('Office of Rural Health')
        click_save
        visit_practice
        expect(page).to have_no_content('Diffusion of Excellence')
        expect(page).to have_no_content('Office of Rural Health')
        visit practice_introduction_path(@practice)
        find('#practice_partner_1_label').click # clicks Diffusion of Excellence
        expect(page).to have_unchecked_field('None of the above, or Unsure')
        click_save
        visit_practice
        expect(page).to have_content('Diffusion of Excellence')
        expect(page).to have_no_content('Office of Rural Health')
      end
    end
  end
end

def click_save
  find('#practice-editor-save-button').click
end

def visit_practice
  visit practice_path(@practice)
end
