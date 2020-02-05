require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'tosen.kaname@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user = User.create!(email: 'jushiro.ukitake@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
  end

  describe 'Checklist page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_checklist_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      @save_progress = find('#practice-editor-save-button')
    end

    it 'should be there' do
      expect(page).to have_content('Checklist')
      expect(page).to have_link(class: 'editor-back-to-link', href: "/practices/#{@practice.slug}/edit/contact")
    end

    it 'should require the user to fill out the fields that are marked as required' do
      @save_progress.click
      permisson_message = page.find('.permission-name-input').native.attribute('validationMessage')
      expect(permisson_message).to eq('Please fill out this field.')
      within(:css, '#sortable_permissions') do
        fill_in('Step', with: 'Permission 1')
      end
      @save_progress.click
      resource_name_message = page.find('.resource-name-input').native.attribute('validationMessage')
      expect(resource_name_message).to eq('Please fill out this field.')
    end

    it 'when no data is present, should allow the user to add a practice permission and additional resource' do

      within(:css, '#sortable_permissions') do
        fill_in('Step', with: 'Permission 1')
        fill_in('Description', with: 'Permission description 1')
      end

      within(:css, '#sortable_resources') do
        fill_in('Step', with: 'Resource 1')
        fill_in('Description', with: 'Resource description 1')
      end
      @save_progress.click
      expect(page).to have_current_path("/practices/#{@practice.slug}/edit/checklist")


      expect(page).to have_content('Practice was successfully updated.')
      expect(page).to have_field('practice[practice_permissions_attributes][0][name]', with: 'Permission 1')
      expect(page).to have_field('practice[practice_permissions_attributes][0][description]', with: 'Permission description 1')
      expect(page).to have_field('practice[additional_resources_attributes][0][name]', with: 'Resource 1')
      expect(page).to have_field('practice[additional_resources_attributes][0][description]', with: 'Resource description 1')
    end

    it 'should allow the user to add multiple permissions and resources' do
      within(:css, '#sortable_permissions') do
        fill_in('Step', with: 'Permission 1')
        fill_in('Description', with: 'Permission description 1')
      end

      within(:css, '#sortable_resources') do
        fill_in('Step', with: 'Resource 1')
        fill_in('Description', with: 'Resource description 1')
      end

      find('.add-permission-link').click
      find('.add-resource-link').click

      all('.permission-name-input').last.set('Permission 2')
      all('.resource-name-input').last.set('Resource 2')

      find('#practice-editor-save-button').click

      expect(page).to have_content('Practice was successfully updated')
      expect(page).to have_field('practice[practice_permissions_attributes][0][name]', with: 'Permission 1')
      expect(page).to have_field('practice[practice_permissions_attributes][0][description]', with: 'Permission description 1')
      expect(page).to have_field('practice[practice_permissions_attributes][1][name]', with: 'Permission 2')
      expect(page).to have_field('practice[additional_resources_attributes][0][name]', with: 'Resource 1')
      expect(page).to have_field('practice[additional_resources_attributes][0][description]', with: 'Resource description 1')
      expect(page).to have_field('practice[additional_resources_attributes][1][name]', with: 'Resource 2')
    end

    it 'should allow the user to delete resources and permissions' do
      within(:css, '#sortable_permissions') do
        fill_in('Step', with: 'Permission 1')
        fill_in('Description', with: 'Permission description 1')
      end

      within(:css, '#sortable_resources') do
        fill_in('Step', with: 'Resource 1')
        fill_in('Description', with: 'Resource description 1')
      end
      @save_progress.click

      find('.permission-trash').click
      find('.resource-trash').click
      @save_progress.click

      within(:css, '#sortable_permissions') do
        expect(page).to have_field('Step', with: nil)
        expect(page).to have_field('Description', with: nil)
      end
      within(:css, '#sortable_resources') do
        expect(page).to have_field('Step', with: nil)
        expect(page).to have_field('Description', with: nil)
      end
    end
  end
end