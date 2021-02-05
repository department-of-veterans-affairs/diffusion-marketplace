require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @pr_no_resources = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement', user: @admin)
    @pr_with_resources = Practice.create!(name: 'A practice with resources', slug: 'practice-with-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'problem statement', overview_solution: 'solution statement', overview_results: 'results statement', user: @admin)
    @video_url_1 = 'https://www.youtube.com/watch?v=00ehNfVIhUA'
    @video_url_2 = 'https://www.youtube.com/watch?v=Ck6zBU-AOpc'
    @video_url_3 = 'https://www.youtube.com/watch?v=IRfSW4TWdhg'
    PracticeProblemResource.create(practice: @pr_with_resources, name: 'existing problem video',link_url: @video_url_1, resource_type: 1)
    PracticeSolutionResource.create(practice: @pr_with_resources, name: 'existing solution video', link_url: @video_url_1, resource_type: 1)
    PracticeResultsResource.create(practice: @pr_with_resources, name: 'existing results video',  link_url: @video_url_1, resource_type: 1)
    PracticeMultimedium.create(practice: @pr_with_resources, name: 'existing multimedia video',  link_url: @video_url_1, resource_type: 1)
    @frame_index = { problem: 0, solution: 1, results: 2, multimedia: 3 }
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Overview page -- resource & multimedia video:' do
    describe 'default view' do
      context 'with no saved videos' do
        before do
          no_resource_pr_test_setup
        end

        it 'should not display the video resource form' do
          expect(page).to have_no_content('Link (paste the full Youtube address)')
          expect(page).to have_no_content('Caption')
          expect(page).to have_no_css('#problem_resources_video_form')
          expect(page).to have_no_css('#solution_resources_video_form')
          expect(page).to have_no_css('#results_resources_video_form')
          expect(page).to have_no_css('#multimedia_video_form')
        end
      end

      context 'with saved resources' do
        before do
          with_resource_pr_test_setup
        end

        def saved_video_display_test(area)
          within(:css, "##{area}_section") do
            expect(page).to have_content('VIDEOS')
            expect(url_field.value).to eq(@video_url_1)
            expect(caption_field.value).to eq("existing #{area} video")
            expect(page).to have_content('Delete entry')
          end
        end

        it 'should display the saved videos' do
          saved_video_display_test 'problem'
          saved_video_display_test 'solution'
          saved_video_display_test 'results'
          saved_video_display_test 'multimedia'
        end
      end
    end

    describe 'complete form and add video' do
      before do
        no_resource_pr_test_setup
      end

      def cancel_form(area)
        area_name = area == 'multimedia' ? area : "#{area}_resources"
        find("#cancel_#{area_name}_video").click
      end

      def complete_add_video_test(area)
        area_name = set_area_name area
        within(:css, "##{area}_section") do
          click_video_form area
          expect(page).to have_content('Link (paste the full Youtube address)')
          expect(page).to have_content('Caption')
          add_resource
          expect(page).to have_content('Please enter a valid YouTube url')
          url_field.set(@video_url_2)
          add_resource
          expect(page).to have_content('Please enter a caption')
          caption_field.set("new practice #{area} video")
          add_resource
          expect(find_all('.overview_error_msg').length).to eq 0

          within(:css, "##{area_name}_video_form") do
            expect(url_field.value).to eq ''
            expect(caption_field.value).to eq ''
          end
          cancel_form area
          expect(page).to have_no_css("##{area_name}_video_form")
        end

        within(:css, "#display_#{area_name}_video") do
          expect(page).to have_content('VIDEOS')
          expect(url_field.value).to eq(@video_url_2)
          expect(caption_field.value).to eq("new practice #{area} video")
          expect(page).to have_content('Delete entry')
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_content("Videos")
        expect(page).to have_content("new practice #{area} video")
        within_frame(0) do
          expect(page).to have_link('Facing the Challenge (30s)', href: @video_url_2)
        end
      end

      it 'problem section - should save video' do
        complete_add_video_test 'problem'
      end

      it 'solution section - should save video' do
        complete_add_video_test 'solution'
      end

      it 'results section - should save video' do
        complete_add_video_test 'results'
      end

      it 'multimedia section - should save video' do
        complete_add_video_test 'multimedia'
      end
    end

    describe 'edit newly added videos' do
      before do
        no_resource_pr_test_setup
      end

      def edit_added_video_test(area)
        area_name = set_area_name area
        within(:css, "##{area}_section") do
          click_video_form area
          url_field.set(@video_url_2)
          caption_field.set("new practice #{area} video")
          add_resource
        end

        within(:css, "#display_#{area_name}_video") do
          expect(url_field.value).to eq(@video_url_2)
          expect(caption_field.value).to eq("new practice #{area} video")
          url_field.set(@video_url_3)
          caption_field.set("edited practice #{area} video")
        end

        save_practice
        visit practice_path(@pr_no_resources)
        expect(page).to have_content("Videos")
        expect(page).to have_content("edited practice #{area} video")
        within_frame(0) do
          expect(page).to have_no_link('Make the Difference', href: @video_url_1)
          expect(page).to have_no_link('Facing the Challenge (30s)', href: @video_url_2)
          expect(page).to have_link('Marca la Diferencia', href: @video_url_3)
        end
      end

      it 'problem section - should allow user to edit newly added video' do
        edit_added_video_test 'problem'
      end

      it 'solution section - should allow user to edit newly added video' do
        edit_added_video_test 'solution'
      end

      it 'results section - should allow user to edit newly added video' do
        edit_added_video_test 'results'
      end

      it 'multimedia section - should allow user to edit newly added video' do
        edit_added_video_test 'multimedia'
      end
    end

    describe 'edit existing video' do
      before do
        with_resource_pr_test_setup
      end

      def edit_existing_video_test(area)
        area_name = set_area_name area
        within(:css, "#display_#{area_name}_video") do
          url_field.set(@video_url_3)
          caption_field.set("edited practice #{area} video")
        end

        save_practice
        visit practice_path(@pr_with_resources)
        within_frame(@frame_index[area.to_sym]) do
          expect(page).to have_no_link('Make the Difference', href: @video_url_1)
          expect(page).to have_link('Marca la Diferencia', href: @video_url_3)
        end
        expect(page).to have_content("edited practice #{area} video")
      end

      it 'problem section - should allow user to edit existing video' do
        edit_existing_video_test 'problem'
      end

      it 'solution section - should allow user to edit existing video' do
        edit_existing_video_test 'solution'
      end

      it 'results section - should allow user to edit existing video' do
        edit_existing_video_test 'results'
      end

      it 'multimedia section - should allow user to edit existing video' do
        edit_existing_video_test 'multimedia'
      end
    end

    describe 'delete new and existing videos' do
      before do
        with_resource_pr_test_setup
      end

      def delete_entries_test(area)
        area_name = set_area_name area
        within(:css, "#display_#{area_name}_video") do
          click_button('Delete entry')
          expect(page).to have_no_content("existing #{area} video")
        end

        within(:css, "##{area}_section") do
          click_video_form area
          url_field.set(@video_url_2)
          caption_field.set("new practice #{area} video")
          add_resource
        end

        within(:css, "#display_#{area_name}_video") do
          expect(url_field.value).to eq(@video_url_2)
          expect(caption_field.value).to eq("new practice #{area} video")
          click_button('Delete entry')
        end

        save_practice
      end

      it 'should allow user to delete existing video' do
        delete_entries_test 'problem'
        delete_entries_test 'solution'
        delete_entries_test 'results'
        delete_entries_test 'multimedia'
        visit practice_overview_path(@pr_with_resources)
        expect(page).to have_no_content("existing problem video")
        expect(page).to have_no_content("existing solution video")
        expect(page).to have_no_content("existing results video")
        expect(page).to have_no_content("existing multimedia video")
        expect(page).to have_no_content("new practice problem video")
        expect(page).to have_no_content("new practice solution video")
        expect(page).to have_no_content("new practice results video")
        expect(page).to have_no_content("new practice multimedia video")
        expect(page).to have_no_css("iframe")
      end
    end
  end

  def set_area_name(area)
    area == 'multimedia' ? area : "#{area}_resources"
  end

  def url_field
    find_all('input[type="text"]').first
  end

  def caption_field
    find_all('input[type="text"]').last
  end

  def click_video_form(area)
    find("label[for=practice_#{area}_video]").click
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
    expect(page).to have_no_content("Videos")
    visit practice_overview_path(@pr_no_resources)
  end

  def with_resource_pr_test_setup
    visit practice_path(@pr_with_resources)
    expect(page).to have_content('Overview')
    expect(page).to have_content("Videos")
    @frame_index.each do |f, i|
      within_frame(i) do
        expect(page).to have_link('Make the Difference', href: @video_url_1)
      end
    end
    expect(page).to have_content("existing problem video")
    expect(page).to have_content("existing solution video")
    expect(page).to have_content("existing problem video")
    visit practice_overview_path(@pr_with_resources)
  end
end
