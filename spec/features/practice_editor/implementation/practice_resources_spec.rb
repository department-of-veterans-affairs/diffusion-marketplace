require 'rails_helper'
describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Resources Page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_implementation_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    def add_people_resource
      resources_input_1.set('Fred')
      save_progress
      expect(page).to have_content('Practice was successfully updated')
      # Add Another
      find('#link_to_add_link_core_people_resource').click
    end

    def add_core_link
      find('label[for="support_resource_attachment_link"').click
    end

    def resources_input_1
      find_all('.practice-input ').first
    end

    def save_progress
      find('#practice-editor-save-button').click
    end

    it 'should be there' do
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('Core resources list')
      expect(page).to have_content('Core resources attachments')
      expect(page).to have_content('Optional resources list')
      expect(page).to have_content('Optional resources attachments')
      expect(page).to have_content('Support resources list')
      expect(page).to have_content('Support resources attachments')
    end
    it 'should allow user to add multiple resources' do
      add_people_resource
    end
    it 'should allow user to add a core link' do
      add_core_link
    end

    it 'should not allow the user to save unless they have at least one core people resource' do
      save_progress
      core_people_resource_message = resources_input_1.native.attribute('validationMessage')
      expect(core_people_resource_message).to eq('Please fill out this field.')

      resources_input_1.set('A practice person')
      save_progress
      expect(page).to have_content('Practice was successfully updated')
      expect(resources_input_1.value ).to eq('A practice person')
    end
  end
end
