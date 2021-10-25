class PracticesController < ApplicationController
  include CropperUtils, PracticesHelper, PracticeEditorUtils, EditorSessionUtils, PracticeEditorSessionsHelper, PracticeUtils, ThreeColumnDataHelper
  prepend_before_action :skip_timeout, only: [:session_time_remaining]
  before_action :set_practice, only: [:show, :edit, :update, :destroy, :highlight, :un_highlight, :feature,
                                      :un_feature, :favorite, :instructions, :overview, :impact, :resources, :documentation,
                                      :departments, :timeline, :risk_and_mitigation, :contact, :checklist, :publication_validation, :adoptions,
                                      :create_or_update_diffusion_history, :implementation, :introduction, :about, :metrics, :editors,
                                      :extend_editor_session_time, :session_time_remaining, :close_edit_session]
  before_action :set_facility_data, only: [:show]
  before_action :set_office_data, only: [:show]
  before_action :set_visn_data, only: [:show]
  before_action :set_initiating_facility_other, only: [:show]
  before_action :authenticate_user!, except: [:show, :search, :index, :explore, :explore_practices]
  before_action :can_view_practice, only: [:show, :edit, :update, :destroy]
  before_action :can_create_practice, only: :create
  before_action :can_edit_practice, only: [:edit, :update, :instructions, :overview, :contact, :published, :publication_validation, :adoptions, :about, :editors, :introduction, :implementation, :metrics]
  before_action :set_date_initiated_params, only: [:update, :publication_validation]
  before_action :is_enabled, only: [:show]
  before_action :set_current_session, only: [:extend_editor_session_time, :session_time_remaining, :close_edit_session]
  before_action :practice_locked_for_editing, only: [:editors, :introduction, :overview, :contact, :adoptions, :about, :implementation]
  before_action :fetch_visns, only: [:show, :search, :introduction]
  before_action :fetch_va_facilities, only: [:show, :search, :metrics, :adoptions, :create_or_update_diffusion_history, :introduction]

  # GET /practices
  # GET /practices.json
  def index
    redirect_to root_path
  end

  # GET /innovations/1
  # GET /practices/1.json
  def show
    # This allows comments thread to show up without the need to click a link
    commontator_thread_show(@practice)

    @pr_diffusion_histories = @practice.diffusion_histories
    @diffusion_history_markers = Gmaps4rails.build_markers(@pr_diffusion_histories) do |dhg, marker|
      facility = @va_facilities.find { |f| f.station_number === dhg.va_facility.station_number }
      marker.lat facility.latitude
      marker.lng facility.longitude

      current_diffusion_status = dhg.diffusion_history_statuses.first
      marker_url = view_context.image_path('map-marker-successful-default.svg')
      status = 'Complete'
      start_time = current_diffusion_status.start_time
      end_time = current_diffusion_status.end_time
      if current_diffusion_status.status == 'In progress' || current_diffusion_status.status == 'Planning' || current_diffusion_status.status == 'Implementing'
        marker_url = view_context.image_path('map-marker-in-progress-default.svg')
        status = 'In progress'
      elsif current_diffusion_status.status == 'Unsuccessful'
        marker_url = view_context.image_path('map-marker-unsuccessful-default.svg')
        status = 'Unsuccessful'
        unsuccessful_reasons = current_diffusion_status.unsuccessful_reasons
        unsuccessful_reasons_other = current_diffusion_status.unsuccessful_reasons_other
      end

      marker.picture({
                      url: marker_url,
                      width: 31,
                      height: 44,
                      scaledWidth: 31,
                      scaledHeight: 44
                     })
      marker.shadow nil
      marker.json({
                    id: facility.station_number,
                    facility: facility,
                    diffusion_history_status: current_diffusion_status,
                    status: current_diffusion_status.get_status_display_name
                  })
      marker.infowindow render_to_string(partial: 'maps/infowindow', locals: { diffusion_histories: dhg[1], facility: facility })
    end

    render 'practices/show/show'
  end

  # GET /practices/1/edit
  def edit
  end

  # POST /practices
  # POST /practices.json
  def create
    @practice = Practice.new(practice_params)

    respond_to do |format|
      if @practice.save
        format.html { redirect_to @practice, notice: 'Innovation was successfully created.' }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { redirect_back fallback_location: root_path}
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    session_open = PracticeEditorSession.find_by(practice: @practice, user_id: current_user.id, session_end_time: nil).present?
    latest_session_user_is_current_user = PracticeEditorSession.where(practice: @practice).last.user === current_user
    updated = update_conditions if session_open || latest_session_user_is_current_user

    #check to see if current session has expired.... if  not
    respond_to do |format|
      if updated
        editor_params = params[:practice][:practice_editors_attributes]
        if updated.is_a?(StandardError)
          # Add back end validation error messages for Editors page just as a safety measure
          invalid_editor_email_field = updated.message.split(' ').slice(3..-1).join(' ')
          flash[:error] = "There was an #{editor_params.present? && updated.message.include?('valid @va.gov') ? invalid_editor_email_field : updated.message}. The innovation was not saved."
          format.html { redirect_back fallback_location: root_path }
          format.json { render json: updated, status: :unprocessable_entity }
        elsif !session_open && latest_session_user_is_current_user
          flash[:notice] = "Your editing session for #{@practice.name} has ended. Your edits have been saved and you have been returned to the Metrics page."
          format.html { redirect_to practice_metrics_path(@practice) }
        else
          # Add notice messages specific to the Editors page
          editor_notice = ''
          if editor_params.present? && editor_params.keys.include?('_destroy')
            editor_notice = 'Editor was removed from the list. '
          elsif editor_params.present? && editor_params.values.first.values.first.present?
            editor_notice = 'Editor was added to the list. '
          end
          if params[:next]
            path = eval("practice_#{Practice::PRACTICE_EDITOR_SLUGS.key(current_endpoint)}_path(@practice)")
            format.html { redirect_to path, notice: params[:practice].present? ? editor_notice + 'Innovation was successfully updated.' : nil }
            format.json { render :show, status: :ok, location: @practice }
          else
            format.html { redirect_back fallback_location: root_path, notice: editor_notice + 'Innovation was successfully updated.' }
            format.json { render json: @practice, status: :ok }
          end
          # Update last_edited field for the Practice Editor unless the current_user is the Practice Editor and their Practice Editor record was just created
          practice_editor = PracticeEditor.find_by(practice: @practice, user: current_user)
          if practice_editor.present? && Time.current - practice_editor.created_at > 2
            practice_editor.update_attributes(last_edited_at: DateTime.current)
          end
        end
      else
        if !session_open
          flash[:error] = "Your editing session for #{@practice.name} has ended. Your edits have not been saved and you have been returned to the Metrics page."
          format.html { redirect_to practice_metrics_path(@practice) }
        else
          flash[:error] = "There was an #{@practice.errors.messages}. The innovation was not saved."
          format.html { redirect_back fallback_location: root_path }
          format.json { render json: updated, status: :unprocessable_entity }
        end
      end
    end
  end

  def search
    @practices = Practice.searchable_practices(nil)
    # due to some practices/search.js.erb functions being reused for other pages (VISNs/VA Facilities), set the @practices_json variable to nil unless it's being used for the practices/search page
    @practices_json = cached_json_practices
    @diffusion_histories = []
    @practices.each do |p|
      p.diffusion_histories.each do |dh|
        @diffusion_histories << {practice_id: dh.practice_id, facility_number: dh.va_facility.station_number}
      end
    end
    @parent_categories = Category.get_parent_categories
  end

  # GET /explore
  def explore
    @categories = Category.with_practices
    practices = Practice.searchable_practices 'a_to_z'
    @pagy_practices = pagy_array(
      practices,
      items: 12
    )
    @pagy_info = @pagy_practices[0]
    @practices = @pagy_practices[1]
    @pr_count = practices.size

    respond_to do |format|
      format.html
    end
  end

  # POST /explore
  def explore_practices
    @categories = Category.with_practices
    page = 1
    page = params[:page].to_i if params[:page].present?

    @sort_option = params[:sort_option] || 'a_to_z'
    @cat_filters = params[:categories] ? params[:categories].map { |cat| cat.to_i } : []
    practices = Practice.searchable_practices @sort_option
    if @cat_filters.length > 0
      filtered_practices = practices.select { |pr| !(pr.category_ids & @cat_filters).empty? }
      practices = filtered_practices
    end

    @pagy_practices = pagy_array(
      practices,
      items: 12,
      page: page
    )
    @pagy_info = @pagy_practices[0]
    @practices = @pagy_practices[1]
    practice_cards_html = ''
    @practices.each do |pr|
      pr_html = render_to_string('shared/_practice_card', layout: false, locals: { practice: pr })
      practice_cards_html += pr_html
    end
    respond_to do |format|
      format.html
      format.json { render :json => { practice_cards_html: practice_cards_html, count: practices.size, next: @pagy_info.next } }
    end
  end

  # POST /practices/1/favorite.js
  # POST /practices/1/favorite.json
  def favorite
    user_practice = UserPractice.find_by(user: current_user, practice: @practice)

    if user_practice.present? && user_practice.favorited
      user_practice.update_attributes(favorited: false)
    elsif user_practice.present? && !user_practice.favorited
      user_practice.update_attributes(favorited: true, time_favorited: DateTime.now)
    else
      user_practice = UserPractice.create(user: current_user, practice: @practice, favorited: true, time_favorited: DateTime.now)
    end

    @favorited = user_practice.favorited

    respond_to do |format|
      if user_practice.save
        format.js
        format.json { render json: {favorited: user_practice.favorited}, status: :success }
      else
        format.js { redirect_back fallback_location: root_path, error: user_practice.errors }
        format.json { render json: user_practice.errors, status: :unprocessable_entity }
      end
    end
  end

  def highlight
    old_highlight = Practice.find_by_highlight(true)
    old_highlight.update_attributes(highlight: false) if old_highlight.present?
    @practice.update_attributes highlight: true, featured: false
    redirect_to edit_practice_path(@practice)
  end

  def un_highlight
    @practice.update_attributes highlight: false
    redirect_to edit_practice_path(@practice)
  end

  def feature
    @practice.update_attributes featured: true
    redirect_to edit_practice_path(@practice)
  end

  def un_feature
    @practice.update_attributes featured: false
    redirect_to edit_practice_path(@practice)
  end

  # GET /practices/1/instructions
  def instructions
    render 'practices/form/instructions'
  end

  # /practices/slug/overview
  def overview
    render 'practices/form/overview'
  end

  def metrics
    @duration = params[:duration] || "30"
    @page_views_leader_board_30_days = fetch_page_views_leader_board
    @page_views_leader_board_all_time = fetch_page_views_leader_board(0)
    @page_views_for_practice_count = fetch_page_view_for_practice_count(@practice.id, @duration)
    @unique_visitors_for_practice_count = fetch_unique_visitors_by_practice_count(@practice.id, @duration)
    @bookmarks_by_practice = fetch_bookmarks_by_practice(@practice.id, @duration)
    @adoptions_by_practice = fetch_adoptions_by_practice(@practice.id, @duration)

    @adoptions_total_30 = fetch_adoptions_total_by_practice(@practice.id)
    @adoptions_total_at = fetch_adoptions_total_by_practice(@practice.id, "0")

    @adoptions_successful_total_30 = fetch_adoptions_total_by_practice(@practice.id, "30", "Completed")
    @adoptions_successful_total_at = fetch_adoptions_total_by_practice(@practice.id, "0", "Completed")
    @adoptions_in_progress_total_30 = fetch_adoptions_total_by_practice(@practice.id, "30", "In progress")
    @adoptions_in_progress_total_at = fetch_adoptions_total_by_practice(@practice.id, "0", "In progress")
    @adoptions_unsuccessful_total_30 = fetch_adoptions_total_by_practice(@practice.id, "30", "Unsuccessful")
    @adoptions_unsuccessful_total_at = fetch_adoptions_total_by_practice(@practice.id, "0", "Unsuccessful")

    @facility_ids_for_practice_30 = fetch_adoption_facilities_for_practice(@practice.id, "30", @va_facilities)
    @rural_facility_30 = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_30, "rurality", "R")
    @urban_facility_30 = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_30, "rurality", "U")
    @a_high_complexity_30 = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_30, "fy17_parent_station_complexity_level", "1a-High Complexity")
    @b_high_complexity_30 = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_30, "fy17_parent_station_complexity_level", "1b-High Complexity")
    @c_high_complexity_30 = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_30, "fy17_parent_station_complexity_level", "1c-High Complexity")
    @medium_complexity_2_30 = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_30, "fy17_parent_station_complexity_level", "2 -Medium Complexity")
    @low_complexity_3_30 = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_30, "fy17_parent_station_complexity_level", "3 -Low Complexity")

    @facility_ids_for_practice_at = fetch_adoption_facilities_for_practice(@practice.id, "0", @va_facilities)
    @rural_facility_at = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_at, "rurality", "R")
    @urban_facility_at = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_at, "rurality", "U")
    @a_high_complexity_at = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_at, "fy17_parent_station_complexity_level", "1a-High Complexity")
    @b_high_complexity_at = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_at, "fy17_parent_station_complexity_level", "1b-High Complexity")
    @c_high_complexity_at = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_at, "fy17_parent_station_complexity_level", "1c-High Complexity")
    @medium_complexity_2_at = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_at, "fy17_parent_station_complexity_level", "2 -Medium Complexity")
    @low_complexity_3_at = get_adoption_facility_details_for_practice(@va_facilities, @facility_ids_for_practice_at, "fy17_parent_station_complexity_level", "3 -Low Complexity")

    # Charts.....
    @unique_visitors_for_practice = fetch_unique_visitors_by_practice(@practice.id, @duration)
    @page_views_for_practice = fetch_page_views_for_practice(@practice.id, @duration)

    if @duration != "30"
      @duration = get_practice_all_time_duration(@practice.id)
    end
    @month_names = "Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    @cur_duration = @duration.to_i
    @dates = ((@cur_duration.days.ago.to_date .. 0.days.ago.to_date).to_a).map(&:to_s)
    @views = []
    @visitors = []
      @dates.each do |date|
        objCtr = 0
        @page_views_for_practice.each do |obj|
          objCtr += 1 if obj[:created_at].to_s == date.to_s
        end
        @views << objCtr
      end
    @unique_visitors = []
    @dates.each do |date|
      @unique_visitors << fetch_unique_visitors_by_practice_and_date(@practice.id, date)
    end

    render 'practices/form/metrics'
  end

  def practice_name
    render 'practices/form/instructions'
  end

  def implementation
    render 'practices/form/implementation'
  end

  # /practices/slug/editors
  def editors
    render 'practices/form/editors'
  end

  # /practices/slug/introduction
  def introduction
    @parent_categories = Category.get_parent_categories
    render 'practices/form/introduction'
  end

  # /practices/slug/impact
  # redirect to instructions page due to removal of impact page 11/19/20
  def impact
    redirect_to_instructions_path
  end

  # /practices/slug/documentation
  # redirect to instructions page due to removal of impact page 11/19/20
  def documentation
    redirect_to_instructions_path
  end

  # /practices/slug/resources
  # redirect to instructions page due to removal of impact page 11/19/20
  def resources
    redirect_to_instructions_path
  end

  # /practices/slug/departments
  def departments
    redirect_to_instructions_path
  end

  # /practices/slug/timeline
  def timeline
    redirect_to_instructions_path
  end

  # /practices/slug/risk_and_mitigation
  def risk_and_mitigation
    redirect_to_instructions_path
  end

  # /practices/slug/contact
  def contact
    render 'practices/form/contact'
  end

  # /practices/slug/about
  def about
    render 'practices/form/about'
  end

  # /practices/slug/checklist
  def checklist
    redirect_to_instructions_path
  end

  def published
  end

  # /practices/slug/adoptions
  def adoptions
    render 'practices/form/adoptions'
  end

  def publication_validation
    updated = update_conditions
    respond_to do |format|
      if can_publish
        # if there is an error with updating the practice, alert the user
        if updated.is_a?(StandardError)
          flash[:error] = "There was an #{updated.message}. The innovation was not saved or published."
          format.js { redirect_to self.send("practice_#{current_endpoint}_path", @practice) }
        else
          @practice.update_attributes(published: true, date_published: DateTime.now)
          flash[:notice] = "#{@practice.name} has been successfully published to the Diffusion Marketplace"
          format.js { render js: "window.location='#{practice_path(@practice)}'" }
        end
      else
        format.js
      end
    end
  end

  def create_or_update_diffusion_history
    # set attributes for later use
    facility_id = params[:va_facility_id].to_i
    status = params[:status]
    unsuccessful_reasons = params[:unsuccessful_reasons] || []
    unsuccessful_reasons_other = params[:unsuccessful_reasons_other] || nil

    if params[:date_started].present? && !(params[:date_started].values.include?(''))
      start_time = DateTime.new(params[:date_started][:year].to_i, params[:date_started][:month].to_i)
    end
    if (params[:date_ended].present? && !(params[:date_ended].values.include?(''))) && params[:status].downcase != 'in progress'
      end_time = DateTime.new(params[:date_ended][:year].to_i, params[:date_ended][:month].to_i)
    end

    # if there is a diffusion_history_id, we're updating something
    @dh = DiffusionHistory.find(params[:diffusion_history_id]) if params[:diffusion_history_id].present?
    if @dh.present?
      # is the user changing to a facility that they already have listed?
      # if so, tell them no
      existing_dh = DiffusionHistory.find_by(practice: @practice, va_facility_id: facility_id)
      if existing_dh && existing_dh.id != @dh.id
        params[:existing_dh] = @va_facilities.find(facility_id)
      end
    else
      # or else, we're creating something
      # figure out if the user already has this diffusion history
      @dh = DiffusionHistory.find_by(practice: @practice, va_facility_id: facility_id)
      # if so, tell them!
      if @dh
        params[:exists] = @va_facilities.find(facility_id)
      else
        # if not, create a new one
        @dh = DiffusionHistory.create(practice: @practice, va_facility_id: facility_id)
      end
    end

    if params[:exists].blank? && params[:existing_dh].blank?
      if params[:diffusion_history_status_id]
        # update the diffusion history status
        dhs = DiffusionHistoryStatus.find(params[:diffusion_history_status_id])
        params[:updated] = dhs.update_attributes(status: status, start_time: start_time, end_time: end_time, unsuccessful_reasons: unsuccessful_reasons, unsuccessful_reasons_other: unsuccessful_reasons_other)
      else
        # create a new status.
        DiffusionHistoryStatus.create!(diffusion_history: @dh, status: status, start_time: start_time, end_time: end_time, unsuccessful_reasons: unsuccessful_reasons, unsuccessful_reasons_other: unsuccessful_reasons_other)
      end
    end

    respond_to do |format|
      if params[:diffusion_history_id].blank? && params[:exists].blank?
        params[:created] = true
      end
      params[:reload] = true
      format.js { render 'practices/form/adoptions_forms/create_or_update_diffusion_history.js.erb' }
    end
  end

  def destroy_diffusion_history
    dh = DiffusionHistory.find(params[:diffusion_history_id])
    dh.destroy
    respond_to do |format|
      format.html { redirect_to practice_adoptions_path(dh.practice), notice: 'Adoption was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def extend_editor_session_time
    if @current_session.present? && @current_session.user === current_user
      PracticeEditorSession.extend_current_session(@current_session)
    else
      msg = "You cannot edit this innovation since it is currently being edited by #{session_username(@current_session)}"
      render :js => "window.location = '#{practice_metrics_path(@practice)}'"
      flash[:warning] = msg
    end
  end

  def session_time_remaining
    minutes_left = PracticeEditorSession.get_minutes_remaining_in_session(@current_session, @practice.published)
    data = minutes_left.to_s
    render :json => data
  end

  def close_edit_session
    if @current_session.present? && @current_session.user === current_user
      PracticeEditorSession.close_current_session(@current_session)
    end
    if params[:any_blank_required_fields] === 'true' || params[:current_action] === 'adoptions' || params[:current_action] === 'editors'
      render :js => "window.location = '#{practice_metrics_path(@practice)}'"
      flash[:error] = "The innovation was not saved#{params[:any_blank_required_fields] === 'true' ? ' due to one or more required fields not being filled out' : ''}."
    end
  end

  private

  def skip_timeout
    request.env["devise.skip_trackable"] = true
  end

  def is_enabled
    unless @practice.enabled
      redirect_to(root_path)
    end
  end

  def redirect_to_instructions_path
    redirect_to practice_instructions_path(@practice)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_practice
    id = params[:id] || params[:practice_id] || params[:practice_id]
    @practice = Practice.friendly.find(id)
  end

  def set_current_session
    @current_session = current_session(@practice.id)
  end

  def practice_locked_for_editing
    set_current_session
    cur_user_id = current_user[:id]
    # if not locked - lock the practice for editing (for the current user)
    if @current_session.nil? || PracticeEditorSession.session_out_of_time(@current_session)
      PracticeEditorSession.lock_practice_for_user(cur_user_id, @practice.id)
    else
      if @current_session.user != current_user
        msg = "You cannot edit this innovation since it is currently being edited by #{session_username(@current_session)}"
        respond_to do |format|
          flash[:warning] = msg
          format.html { redirect_to practice_metrics_path(@practice), warning: msg }
        end
       end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def practice_params
    params.require(:practice).permit(:need_training, :short_name, :tagline, :process, :it_required, :need_new_license, :description, :name, :initiating_facility, :summary, :origin_title, :origin_story, :cost_to_implement_aggregate, :sustainability_aggregate, :veteran_satisfaction_aggregate, :difficulty_aggregate, :date_initiated,
                                     :number_adopted, :number_departments, :number_failed, :implementation_time_estimate, :implementation_time_estimate_description, :implentation_summary, :implentation_fte,
                                     :training_provider, :training_length, :training_test, :training_provider_role, :required_training_summary, :support_network_email,
                                     :initiating_facility_type, :initiating_department_office_id,
                                     :main_display_image, :crop_x, :crop_y, :crop_h, :crop_w,
                                     :tagline, :delete_main_display_image,
                                     :origin_picture, :origin_picture_original_w, :origin_picture_original_h, :origin_picture_crop_x, :origin_picture_crop_y, :origin_picture_crop_w, :origin_picture_crop_h,
                                     :overview_problem, :overview_solution, :overview_results, :maturity_level,
                                     impact_photos_attributes: [:id, :title, :is_main_display_image, :description, :position, :attachment, :attachment_original_w, :attachment_original_h, :attachment_crop_x, :attachment_crop_y,
                                                                :attachment_crop_w, :attachment_crop_h, :_destroy],
                                     video_files_attributes: [:id, :title, :description, :url, :position, :attachment, :attachment_original_w, :attachment_original_h, :attachment_crop_x, :attachment_crop_y,
                                                              :attachment_crop_w, :attachment_crop_h, :_destroy],
                                     difficulties_attributes: [:id, :description, :_destroy],
                                     risk_mitigations_attributes: [:id, :_destroy, :position, risks_attributes: [:id, :description, :_destroy], mitigations_attributes: [:id, :description, :_destroy]],
                                     timelines_attributes: [:id, :description, :milestone, :timeline, :_destroy, :position],
                                     va_employees_attributes: [:id, :name, :role, :_destroy],
                                     additional_staffs_attributes: [:id, :_destroy, :title, :hours_per_week, :duration_in_weeks, :permanent],
                                     additional_resources_attributes: [:id, :_destroy, :name, :position, :description],
                                     required_staff_trainings_attributes: [:id, :_destroy, :title, :description],
                                     practice_creators_attributes: [:id, :_destroy, :name, :role, :avatar, :position, :delete_avatar, :crop_x, :crop_y, :crop_w, :crop_h],
                                     publications_attributes: [:id, :_destroy, :title, :link, :position],
                                     additional_documents_attributes: [:id, :_destroy, :attachment, :title, :position],
                                     practice_permissions_attributes: [:id, :_destroy, :position, :name, :description],
                                     practice_partner: {},
                                     department: {},
                                     category: {},
                                     practice_award: {},
                                     practice_resources_attributes: {},
                                     practice_problem_resources_attributes: {},
                                     practice_solution_resources_attributes: {},
                                     practice_results_resources_attributes: {},
                                     practice_multimedia_attributes: {},
                                     practice_email: {},
                                     practice_testimonials_attributes: [:id, :_destroy, :testimonial, :author, :position],
                                     practice_awards_attributes: [:id, :_destroy, :name],
                                     categories_attributes: [:id, :_destroy, :name, :parent_category_id, :is_other],
                                     practice_origin_facilities_attributes: [:id, :_destroy, :facility_id, :facility_type, :initiating_department_office_id, :va_facility_id],
                                     practice_metrics_attributes: [:id, :_destroy, :description],
                                     practice_emails_attributes: [:id, :address, :_destroy],
                                     duration: {},
                                     practice_editors_attributes: [:id, :email, :_destroy]

    )
  end

  def can_view_practice
    # if practice is not published
    unless @practice.published && @practice.approved
      unauthorized_response if current_user.blank?
      prevent_practice_permissions if current_user.present?
    end
  end

  def can_edit_practice
    prevent_practice_permissions
  end

  def can_create_practice
    current_user.has_role? :admin
  end

  def prevent_practice_permissions
    # if the user is the practice owner or the user is an admin or approver/practice_editor
    unless @practice.user_id == current_user.id || current_user&.roles.any? || is_user_an_editor_for_practice(@practice, current_user)
      unauthorized_response
    end
  end

  def unauthorized_response
    respond_to do |format|
      warning = 'You are not authorized to view this content.'
      flash[:warning] = warning
      format.html { redirect_to '/', warning: warning }
      format.json { render warning: warning }
    end
  end

  def fetch_va_facilities
    @va_facilities = VaFacility.cached_va_facilities.get_relevant_attributes
  end

  def set_facility_data
    if @practice.facility?
      @facility_data = []
      @practice.practice_origin_facilities.each do |pof|
        @facility_data << pof.va_facility
      end
    end
  end

  def set_office_data
    practice_department_id = @practice.initiating_department_office_id
    @office_data = origin_data_json['departments'][practice_department_id - 1]['offices'].find { |o| o['id'] == @practice.initiating_facility.to_i } if @practice.department?
  end

  def fetch_visns
    @visns = Visn.cached_visns
  end

  def set_visn_data
    @visn_data = Visn.cached_visns.get_by_initiating_facility(@practice.initiating_facility.to_i) if @practice.visn?
  end

  def cached_json_practices
    Rails.cache.fetch('searchable_practices_json') do
      practices_json(Practice.sort_by_retired.get_with_categories_and_adoptions_ct)
    end
  end

  def set_initiating_facility_other
    @initiating_facility_other = @practice.initiating_facility if @practice.other?
  end

  def create_date_initiated(date_initiated)
    if date_initiated && (date_initiated[:year].present? && date_initiated[:month].present?)
      Date.new(date_initiated[:year].to_i, date_initiated[:month].to_i)
    end
  end

  def set_date_initiated_params
    if params[:date_initiated].present? && !(params[:date_initiated].values.include? nil)
      params[:practice][:date_initiated] = create_date_initiated(params[:date_initiated])
    end
  end

  def can_publish
    if @practice.name.present? && @practice.initiating_facility_type.present? && @practice.date_initiated.present? && @practice.summary.present? && @practice.support_network_email.present? && @practice.diffusion_histories.present?
      @practice.has_facility? && @practice.tagline.present? && @practice.overview_problem.present? && @practice.overview_solution.present? && @practice.overview_results.present?
    else
      false
    end
  end

  def current_endpoint
    request.referrer.split('/').pop
  end

  def update_conditions
    if params[:practice].present?
      facility_type = params[:practice][:initiating_facility_type] || nil
      if facility_type.present?
        set_initiating_fac_params params
      end
      pr_params = {practice: @practice, practice_params: practice_params, current_endpoint: current_endpoint}
      updated = SavePracticeService.new(pr_params).save_practice
      clear_origin_facilities if facility_type != "facility" && current_endpoint == 'introduction' && !updated.is_a?(StandardError)
      updated
    end
  end
end

def clear_origin_facilities
  origin_facilities = @practice.practice_origin_facilities
  origin_facilities.destroy_all
end

def set_initiating_fac_params(params)
  facility_type = params[:practice][:initiating_facility_type]

  if facility_type == "facility"
    params[:practice][:practice_origin_facilities_attributes].values.each do |value|
      if value[:va_facility_id].nil?
        params[:practice][:practice_origin_facilities_attributes] = nil
      end
    end
    @practice.initiating_facility = ""
    @practice.initiating_department_office_id = ""
  elsif facility_type == "visn"
    if params[:editor_visn_select].present?
      @practice.initiating_facility = params[:editor_visn_select]
      @practice.initiating_department_office_id = ""
    else
      @practice.initiating_facility = ""
    end
  elsif facility_type == "department"
    if params[:editor_office_state_select].present? && params[:practice][:initiating_department_office_id].present? && params[:practice][:initiating_facility]
      @practice.initiating_facility = params[:practice][:initiating_facility]
      @practice.initiating_department_office_id = params[:practice][:initiating_department_office_id]
    else
      @practice.initiating_facility = ""
    end
  elsif facility_type == "other"
    if params[:initiating_facility_other].present?
      @practice.initiating_facility = params[:initiating_facility_other]
      @practice.initiating_department_office_id = ""
    else
      @practice.initiating_facility = ""
    end
  end
end


