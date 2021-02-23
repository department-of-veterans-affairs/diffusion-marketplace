require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @pr_no_resources = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement', user: @admin)
    @pr_with_resources = Practice.create!(name: 'A practice with resources', slug: 'practice-with-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement', user: @admin)
    @link_url_1 = 'https://www.google.com/'
    @link_url_2 = 'https://www.wikipedia.com/'
    @link_url_3 = 'https://www.youtube.com/'
    PracticeProblemResource.create(practice: @pr_with_resources, name: 'existing problem link', description: 'problem link description', link_url: @link_url_1, resource_type: 3)
    PracticeSolutionResource.create(practice: @pr_with_resources, name: 'existing solution link', description: 'solution link description', link_url: @link_url_1, resource_type: 3)
    PracticeResultsResource.create(practice: @pr_with_resources, name: 'existing results link', description: 'results link description', link_url: @link_url_1, resource_type: 3)
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Overview page -- resource link:' do
    describe 'default view' do
      context 'with no saved resources' do
        before do
          no_resource_pr_test_setup
        end

        it 'should not display the link resource form' do
          expect(page).to have_no_content('Link (paste the full address)')
          expect(page).to have_no_content('Title')
          expect(page).to have_no_content('Description')
          expect(page).to have_no_css('#problem_resources_link_form')
          expect(page).to have_no_css('#solution_resources_link_form')
          expect(page).to have_no_css('#results_resources_link_form')
        end
      end

      context 'with saved resources' do
        before do
          with_resource_pr_test_setup
        end

        def saved_link_display_test(area)
          within(:css, "##{area}_section") do
            expect(page).to have_content('LINKS')
            expect(url_field.value).to eq(@link_url_1)
            expect(title_field.value).to eq("existing #{area} link")
            expect(description_field.value).to eq("#{area} link description")
            expect(page).to have_content('Delete entry')
          end
        end

        it 'should display the saved link resources' do
          saved_link_display_test 'problem'
          saved_link_display_test 'solution'
          saved_link_display_test 'results'
        end
      end
    end

    describe 'complete form and add link' do
      before do
        no_resource_pr_test_setup
      end

      def cancel_form(area)
        find("#cancel_#{area}_resources_link").click
      end

      def complete_add_link_test(area)
        within(:css, "##{area}_section") do
          click_link_form area
          expect(page).to have_content('Link (paste the full address)')
          expect(page).to have_content('Title')
          expect(page).to have_content('Description')
          add_resource
          expect(page).to have_content('Please enter a valid url/link')
          url_field.set(@link_url_2)
          add_resource
          expect(page).to have_content('Please enter a link title')
          title_field.set('new link')
          add_resource
          expect(page).to have_content('Please enter a link description')
          description_field.set("new practice #{area} link")
          add_resource
          expect(find_all('.overview_error_msg').length).to eq 0

          within(:css, "##{area}_resources_link_form") do
            expect(url_field.value).to eq ''
            expect(title_field.value).to eq ''
            expect(description_field.value).to eq ''
          end
          cancel_form area
          expect(page).to have_no_css("##{area}_resources_link_form")
        end

        within(:css, "#display_#{area}_resources_link") do
          expect(page).to have_content('LINKS')
          expect(url_field.value).to eq(@link_url_2)
          expect(title_field.value).to eq("new link")
          expect(description_field.value).to eq("new practice #{area} link")
          expect(page).to have_content('Delete entry')
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_content("Links")
        expect(page).to have_content("new link")
        expect(page).to have_content("new practice #{area} link")
        expect(page).to have_css("a[href='#{@link_url_2}']")
      end

      it 'problem section - should save link' do
        complete_add_link_test 'problem'
      end

      it 'solution section - should save link' do
        complete_add_link_test 'solution'
      end

      it 'results section - should save link' do
        complete_add_link_test 'results'
      end
    end

    describe 'edit newly added links' do
      before do
        no_resource_pr_test_setup
      end

      def edit_added_link_test(area)
        within(:css, "##{area}_section") do
          click_link_form area
          url_field.set(@link_url_2)
          title_field.set('new link')
          description_field.set("new practice #{area} link")
          add_resource
        end

        within(:css, "#display_#{area}_resources_link") do
          expect(url_field.value).to eq(@link_url_2)
          expect(title_field.value).to eq("new link")
          expect(description_field.value).to eq("new practice #{area} link")
          url_field.set(@link_url_3)
          title_field.set('edited link')
          description_field.set("edited practice #{area} link")
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_no_link('new link', href: @link_url_2)
        expect(page).to have_link('edited link', href: @link_url_3)
        expect(page).to have_content("edited practice #{area} link")
      end

      it 'problem section - should allow user to edit newly added link' do
        edit_added_link_test 'problem'
      end

      it 'solution section - should allow user to edit newly added link' do
        edit_added_link_test 'solution'
      end

      it 'results section - should allow user to edit newly added link' do
        edit_added_link_test 'results'
      end
    end

    describe 'edit existing link' do
      before do
        with_resource_pr_test_setup
      end

      def edit_existing_link_test(area)
        within(:css, "#display_#{area}_resources_link") do
          url_field.set(@link_url_3)
          title_field.set('edited link')
          description_field.set("edited practice #{area} link")
        end

        save_practice
        visit practice_path(@pr_with_resources)
        expect(page).to have_no_link("existing #{area} link", href: @link_url_1)
        expect(page).to have_link('edited link', href: @link_url_3)
        expect(page).to have_content("edited practice #{area} link")
      end

      it 'problem section - should allow user to edit existing link' do
        edit_existing_link_test 'problem'
      end

      it 'solution section - should allow user to edit existing link' do
        edit_existing_link_test 'solution'
      end

      it 'results section - should allow user to edit existing link' do
        edit_existing_link_test 'results'
      end
    end

    describe 'delete new and existing links' do
      before do
        with_resource_pr_test_setup
      end

      def delete_entries_test(area)
        within(:css, "#display_#{area}_resources_link") do
          click_button('Delete entry')
          expect(page).to have_no_content("existing #{area} link")
          expect(page).to have_no_content("#{area} link description")
        end

        within(:css, "##{area}_section") do
          click_link_form area
          url_field.set(@link_url_2)
          title_field.set('new link')
          description_field.set("new practice #{area} link")
          add_resource
        end

        within(:css, "#display_#{area}_resources_link") do
          expect(url_field.value).to eq(@link_url_2)
          expect(title_field.value).to eq('new link')
          expect(description_field.value).to eq("new practice #{area} link")
          click_button('Delete entry')
        end

        save_practice
        visit practice_overview_path(@pr_with_resources)
        expect(page).to have_no_content("existing #{area} link")
        expect(page).to have_no_content("#{area} link description")
        expect(page).to have_no_content('new link')
        expect(page).to have_no_content("new practice #{area} link")
      end

      it 'problem section - should allow user to delete existing links' do
        delete_entries_test 'problem'
      end

      it 'solution section - should allow user to delete existing links' do
        delete_entries_test 'solution'
      end

      it 'results section - should allow user to delete existing links' do
        delete_entries_test 'results'
      end
    end
  end

  def url_field
    find_all('input[type="text"]').first
  end

  def title_field
    find_all('input[type="text"]')[1]
  end

  def description_field
    find_all('input[type="text"]').last
  end

  def click_link_form(area)
    find("label[for=practice_#{area}_link]").click
  end

  def add_resource
    find('.add-resource').click
  end

  def save_practice
    find('#practice-editor-save-button').click
  end

  def no_resource_pr_test_setup
    visit practice_path(@pr_no_resources)
    expect(page).to have_content('Overview')
    expect(page).to have_no_content("Links")
    visit practice_overview_path(@pr_no_resources)
  end

  def with_resource_pr_test_setup
    visit practice_path(@pr_with_resources)
    expect(page).to have_content('Overview')
    expect(page).to have_content("Links")
    expect(page).to have_link('existing problem link', href: @link_url_1)
    expect(page).to have_link('existing solution link', href: @link_url_1)
    expect(page).to have_link('existing results link', href: @link_url_1)
    expect(page).to have_content("problem link description")
    expect(page).to have_content("solution link description")
    expect(page).to have_content("results link description")
    visit practice_overview_path(@pr_with_resources)
  end
end
