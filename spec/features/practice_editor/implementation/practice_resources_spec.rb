require 'rails_helper'
describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Implementation Page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_implementation_path(@practice)
    end

    def add_people_resource
      resources_input_1.set('Fred')
      save_progress
      expect(page).to have_content('Practice was successfully updated')
    end

    def add_core_link
      find('label[for="support_resource_attachment_link"').click
    end

    def resources_input_1
      find_all('.practice-input').first
    end

    def save_progress
      find('#practice-editor-save-button').click
    end

    it 'should be there' do
      # Core
      expect(page).to have_content('Core resources list')
      expect(page).to have_content('Core resources attachments')
      within(:css, '#core-people-resource-resources') do
        expect(page).to have_content('Type a job title, department, and/or discipline another facility would need to involve in implementing your practice. Provide dependencies for implementation (e.g., Clinical Application Coordinator required for 2-4 hours/week for 1-2 weeks).')
        # text input field should be visible even without user clicking "Add resource" button
        expect(page).to have_css('input[type="text"]')
      end
      within(:css, '#core-processes-resource-resources') do
        expect(page).to have_content('Type a process (e.g., method, procedure, training) another facility would need to implement your practice.')
      end
      within(:css, '#core-tools-resource-resources') do
        expect(page).to have_content('Type a tool (e.g., equipment, software, supply) another facility would need to implement your practice.')
      end

      # Optional
      expect(page).to have_content('Optional resources list')
      expect(page).to have_content('Optional resources attachments')
      within(:css, '#optional-people-resource-resources') do
        expect(page).to have_content('Type a job title, department, and/or discipline another facility could involve in implementing your practice. Provide dependencies for implementation (e.g., Clinical Application Coordinator required for 2-4 hours/week for 1-2 weeks).')
        expect(page).to have_no_css('input[type="text"]')
      end
      within(:css, '#optional-processes-resource-resources') do
        expect(page).to have_content('Type a process (e.g., method, procedure) another facility can consider when implementing your practice.')
      end
      within(:css, '#optional-tools-resource-resources') do
        expect(page).to have_content('Type a tool (e.g., equipment, software, supply) another facility can consider when implementing your practice.')
      end

      # Support
      expect(page).to have_content('Support resources list')
      expect(page).to have_content('Support resources attachments')
      within(:css, '#support-people-resource-resources') do
        expect(page).to have_content('Type the job title of a role your team would provide to another facility, and describe the support that will be provided.')
        expect(page).to have_no_css('input[type="text"]')
      end
      within(:css, '#support-processes-resource-resources') do
        expect(page).to have_content('Type a process (e.g., method, procedure) your team would provide for another facility.')
      end
      within(:css, '#support-tools-resource-resources') do
        expect(page).to have_content('Type a tool (e.g., equipment, software, supply) your team would provide to another facility.')
      end
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

    it 'should not save blank resource fields' do
      add_people_resource

      within(:css, '#core-tools-resource-container') do
        find('#link_to_add_button_core_tools_resource').click
        find('#link_to_add_link_core_tools_resource').click
        find('#link_to_add_link_core_tools_resource').click
        find_all('.practice-input').last.set('A practice tool')
      end
      save_progress
      visit practice_path(@practice)
      expect(page).to have_content('A practice tool')
    end
  end
end
