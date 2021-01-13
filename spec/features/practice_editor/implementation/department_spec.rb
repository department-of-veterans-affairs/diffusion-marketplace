require 'rails_helper'

describe 'Practice', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), initiating_facility_type: 'facility')
    Department.create!(name: 'Admissions', short_name: 'admissions')
    Department.create!(name: 'Anesthetics', short_name: 'anesthetics')
    Department.create!(name: 'Chaplaincy', short_name: 'chaplaincy')
    Department.create!(name: 'None', short_name: 'none')
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Implementation page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
    end

    def set_combobox_val(index, value)
      find_all('.usa-combo-box__input')[index].click
      find_all('.usa-combo-box__input')[index].set(value)
      find_all('.usa-combo-box__list-option').first.click
    end

    def fill_in_core_people_field
      fill_in('Resource', with: 'A practice person')
    end

    it 'should allow the user to update the departments for the practice' do
      # no departments should be there
      visit practice_path(@practice)
      within(:css, '#implementation') do
        expect(page).to have_no_content('Departments')
        expect(page).to have_no_content('Admissions')
        expect(page).to have_no_content('Anesthetics')
        expect(page).to have_no_content('Chaplaincy')
      end

      # navigate to the PE Implementation form
      click_link('Edit')
      visit '/practices/a-public-practice/edit/implementation'
      expect(page).to have_content('Departments')
      expect(page).to have_content('Which departments may be involved during implementation of your practice?')
      expect(page).to have_content('Select a department')
      expect(page).to have_content('Add another')

      fill_in_core_people_field

      # create one department and save
      # no departments should be visible
      expect(page).to have_no_content('Admissions')
      expect(page).to have_no_content('Anesthetics')
      expect(page).to have_no_content('None')

      find('.usa-combo-box__input').click
      expect(page).to have_content('Admissions')
      expect(page).to have_content('Anesthetics')
      expect(page).to have_content('Chaplaincy')
      expect(page).to have_no_content('None') # should not see None option
      set_combobox_val(0, 'Admissions')
      find('#practice-editor-save-button').click
      expect(find_all('.usa-combo-box__input').first.value).to eq 'Admissions'

      # check departments in practice view
      visit practice_path(@practice)
      expect(page).to have_content('Departments')
      expect(page).to have_content('Admissions')
      expect(page).to have_no_content('Anesthetics')
      expect(page).to have_no_content('Chaplaincy')

      # remove department
      visit practice_implementation_path(@practice)
      find('#link_to_add_link_department_practices').click
      set_combobox_val(1, 'Anesthetics')
      find('#link_to_add_link_department_practices').click
      set_combobox_val(2, 'Chaplaincy')
      find_all('.usa-combo-box__clear-input').first.click
      expect(find_all('.usa-combo-box__input').first.value).to eq ''
      find_all('.dm-origin-trash').first.click
      find('#practice-editor-save-button').click
      expect(find_all('.usa-combo-box__input').first.value).to eq 'Anesthetics'
      expect(find_all('.usa-combo-box__input')[1].value).to eq 'Chaplaincy'

      # check departments in practice view
      visit practice_path(@practice)
      expect(page).to have_content('Departments')
      expect(page).to have_no_content('Admissions')
      expect(page).to have_content('Anesthetics')
      expect(page).to have_content('Chaplaincy')

      # edit department
      visit practice_implementation_path(@practice)
      set_combobox_val(0, 'Admissions')
      expect(find_all('.usa-combo-box__input').first.value).to eq 'Admissions'
      find('#practice-editor-save-button').click

      # check departments in practice view
      visit practice_path(@practice)
      expect(page).to have_content('Departments')
      expect(page).to have_content('Admissions')
      expect(page).to have_content('Chaplaincy')
      expect(page).to have_no_content('Anesthetics')
    end
  end
end
