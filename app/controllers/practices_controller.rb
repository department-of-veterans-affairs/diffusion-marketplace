class PracticesController < ApplicationController
  include CropperUtils
  before_action :set_practice, only: [:show, :edit, :update, :destroy, :planning_checklist,
                                      :commit, :committed, :highlight, :un_highlight, :feature,
                                      :un_feature, :favorite, :instructions, :overview, :origin,
                                      :collaborators, :impact, :resources, :documentation,
                                      :departments, :timeline, :risk_and_mitigation, :contact,
                                      :checklist, :publication_validation, :adoptions,
                                      :create_or_update_diffusion_history, :implementation, :introduction, :about]
  before_action :set_facility_data, only: [:show, :planning_checklist]
  before_action :set_office_data, only: [:show, :planning_checklist]
  before_action :set_visn_data, only: [:show, :planning_checklist]
  before_action :set_initiating_facility_other, only: [:show, :planning_checklist]
  before_action :authenticate_user!, except: [:show, :search, :index]
  before_action :can_view_committed_view, only: [:committed]
  before_action :can_view_practice, only: [:show, :edit, :update, :destroy, :planning_checklist]
  before_action :can_create_practice, only: [:new, :create]
  before_action :can_edit_practice, only: [:edit, :update, :instructions,
                                           :overview, :origin, :impact,
                                           :documentation, :resources, :complexity,
                                           :timeline, :risk_and_mitigation,
                                           :contact, :checklist, :published,
                                           :publication_validation, :adoptions, :about]
  before_action :set_date_initiated_params, only: [:update, :publication_validation]
  before_action :is_enabled, only: [:show]
  # GET /practices
  # GET /practices.json
  def index
    # @practices = Practice.where(approved: true, published: true).order(name: :asc)
    # @facilities_data = facilities_json['features']
    redirect_to root_path
  end

  def is_enabled
    unless @practice.enabled
      redirect_to(root_path)
    end
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
    ahoy.track "Practice show", {practice_id: @practice.id} if current_user.present?
    # This allows comments thread to show up without the need to click a link
    commontator_thread_show(@practice)

    @vamc_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))

    @diffused_practices = @practice.diffusion_histories
    @diffusion_histories = Gmaps4rails.build_markers(@diffused_practices.group_by(&:facility_id)) do |dhg, marker|

      facility = @vamc_facilities.find { |f| f['StationNumber'] == dhg[0] }
      marker.lat facility['Latitude']
      marker.lng facility['Longitude']

      current_diffusion_status = dhg[1][0].diffusion_history_statuses.order(id: :desc).first
      marker_url = view_context.image_path('map-marker-default.svg')
      status = 'Complete'
      if current_diffusion_status.status == 'In progress' || current_diffusion_status.status == 'Planning' || current_diffusion_status.status == 'Implementing'
        marker_url = view_context.image_path('map-marker-in-progress-default.svg')
        status = 'In progress'
      elsif current_diffusion_status.status == 'Unsuccessful'
        marker_url = view_context.image_path('map-marker-unsuccessful-default.svg')
        status = 'Unsuccessful'
      end

      marker.picture({
                         url: marker_url,
                         width: 31,
                         height: 44,
                         scaledWidth: 31,
                         scaledHeight: 44
                     })

      marker.shadow nil
      completed = 0
      in_progress = 0
      unsuccessful = 0
      dhg[1].each do |dh|
        dh_status = dh.diffusion_history_statuses.order(created_at: :desc).first
        in_progress += 1 if dh_status.status == 'In progress' || dh_status.status == 'Planning' || dh_status.status == 'Implementing'
        completed += 1 if dh_status.status == 'Completed' || dh_status.status == 'Implemented' || dh_status.status == 'Complete'
        unsuccessful += 1 if dh_status.status == 'Unsuccessful'
      end
      practices = dhg[1].map(&:practice)
      marker.json({
                      id: facility["StationNumber"],
                      practices: practices,
                      name: facility["OfficialStationName"],
                      complexity: facility["FY17ParentStationComplexityLevel"],
                      visn: facility["VISN"],
                      rurality: facility["Rurality"],
                      completed: completed,
                      in_progress: in_progress,
                      unsuccessful: unsuccessful,
                      facility: facility,
                      status: status
                  })

      marker.infowindow render_to_string(partial: 'maps/infowindow', locals: {diffusion_histories: dhg[1], completed: completed, in_progress: in_progress, facility: facility})
    end

    render 'practices/show/show'
  end

  # GET /practices/1/edit
  def edit
  end

  def new
    @practice = Practice.new
  end

  # POST /practices
  # POST /practices.json
  def create
    @practice = Practice.new(practice_params)

    respond_to do |format|
      if @practice.save
        format.html { redirect_to @practice, notice: 'Practice was successfully created.' }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { render :new }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    current_endpoint = request.referrer.split('/').pop
    updated = true
    #raise params.inspect
    if params[:practice].present?
      if params[:practice][:initiating_facility_type].present?
        facility_type = params[:practice][:initiating_facility_type]
        if facility_type == "facility"
          @practice.initiating_facility = params[:editor_facility_select]
          @practice.initiating_department_office_id = ""
        elsif facility_type == "visn"
          @practice.initiating_facility = params[:editor_visn_select]
          @practice.initiating_department_office_id = ""
        elsif facility_type == "department"
          @practice.initiating_facility = params[:editor_office_select]
          @practice.initiating_department_office_id = params[:initiating_department_office_id]
        elsif facility_type == "other"
          @practice.initiating_facility = params[:initiating_facility_other]
          @practice.initiating_department_office_id = ""
        end
      end
      pr_params = {practice: @practice, practice_params: practice_params, current_endpoint: current_endpoint}
      updated = SavePracticeService.new(pr_params).save_practice
      if facility_type != "facility"
        origin_facilities = @practice.practice_origin_facilities
        origin_facilities.destroy_all
      end
    end
    respond_to do |format|
      if updated
        if updated.is_a?(StandardError)
          flash[:error] = "There was an #{updated.message}. The practice was not saved."
          format.html { redirect_back fallback_location: root_path }
          format.json { render json: updated, status: :unprocessable_entity }
        else
          if params[:next]
            path = eval("practice_#{Practice::PRACTICE_EDITOR_SLUGS.key(current_endpoint)}_path(@practice)")
            format.html { redirect_to path, notice: params[:practice].present? ? 'Practice was successfully updated.' : nil }
            format.json { render :show, status: :ok, location: @practice }
          else
            format.html { redirect_back fallback_location: root_path, notice: 'Practice was successfully updated.' }
            format.json { render json: @practice, status: :ok }
          end
        end
      else
        flash[:error] = "There was an #{@practice.errors.messages}. The practice was not saved."
        format.html { redirect_back fallback_location: root_path }
        format.json { render json: updated, status: :unprocessable_entity }
      end
    end
  end

  def search
    @practices = Practice.searchable_practices
    @facilities_data = facilities_json
    @practices_json = practices_json(@practices)

  end

  def planning_checklist
    @facilities_data = facilities_json
  end

  # GET /practices/1/committed
  def committed
    render 'committed'
  end

  # POST /practices/1/commit
  # POST /practices/1/commit.json
  def commit
    user_practice = UserPractice.find_by(user: current_user, practice: @practice, committed: true)

    if user_practice.present?
      flash[:notice] = "You have already committed to this practice. If you did not receive a follow-up email from the practice support team yet, please contact them at #{@practice.support_network_email || ENV['MAILER_SENDER']}"
    else
      user_practice = UserPractice.find_or_initialize_by(user: current_user, practice: @practice)
      user_practice.committed = true
      user_practice.time_committed = DateTime.now
      PracticeMailer.commitment_response_email(user: current_user, practice: @practice).deliver_now
      PracticeMailer.support_team_notification_of_commitment(user: current_user, practice: @practice).deliver_now
    end

    respond_to do |format|
      if user_practice.save
        format.html { redirect_to practice_committed_path(practice_id: @practice.slug), notice: flash[:notice] } if flash[:notice].present?
        format.html { redirect_to practice_committed_path(practice_id: @practice.slug) } if flash[:notice].blank?
        format.json { render :show, status: :created, location: practice_committed_path }
      else
        format.html { render :planning_checklist, error: user_practice.errors }
        format.json { render json: user_practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /practices/1/favorite.js
  # POST /practices/1/favorite.json
  def favorite
    user_practice = UserPractice.find_by(user: current_user, practice: @practice)

    if user_practice.present?
      user_practice.toggle(:favorited)
    else
      user_practice = UserPractice.new(user: current_user, practice: @practice, favorited: true, time_favorited: DateTime.now)
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

  # /practices/slug/collaborators
  def collaborators
    redirect_to practice_overview_path(@practice)
  end

  # /practices/slug/overview
  def overview
    render 'practices/form/overview'
  end

  def implementation
    render 'practices/form/implementation'
  end

  # /practices/slug/introduction
  def introduction
    render 'practices/form/introduction'
  end

  # GET /practices/1/origin
  def origin
  end

  # /practices/slug/impact
  def impact
  end

  # /practices/slug/documentation
  def documentation
  end

  # /practices/slug/resources
  def resources
  end

  # /practices/slug/departments
  def departments
  end

  # /practices/slug/timeline
  def timeline
  end

  # /practices/slug/risk_and_mitigation
  def risk_and_mitigation
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
  end

  def published
  end

  def publication_validation
    current_endpoint = request.referrer.split('/').pop
    if params[:practice].present?
      pr_params = {practice: @practice, practice_params: practice_params, current_endpoint: current_endpoint}
      updated = SavePracticeService.new(pr_params).save_practice
    end
    respond_to do |format|
      if can_publish
        # if there is an error with updating the practice, alert the user
        if updated.is_a?(StandardError)
          flash[:error] = "There was an #{updated.message}. The practice was not saved or published."
          format.js { redirect_to self.send("practice_#{current_endpoint}_path", @practice) }
        else
          @practice.update_attributes(published: true)
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
    facility_id = params[:facility_id]
    status = params[:status]
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
      existing_dh = DiffusionHistory.find_by(practice: @practice, facility_id: facility_id)
      if existing_dh && existing_dh.id != @dh.id
        vamc_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
        params[:existing_dh] = vamc_facilities.find { |f| f['StationNumber'] == facility_id }
      else
        # if not,
        # update it
        @dh.update_attributes(facility_id: facility_id)
        params[:facility_changed] = true
      end
    else
      # or else, we're creating something
      # figure out if the user already has this diffusion history
      @dh = DiffusionHistory.find_by(practice: @practice, facility_id: facility_id)
      # if so, tell them!
      if @dh
        vamc_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
        params[:exists] = vamc_facilities.find { |f| f['StationNumber'] == facility_id }
      else
        # if not, create a new one
        @dh = DiffusionHistory.create(practice: @practice, facility_id: facility_id)
      end
    end

    if params[:exists].blank? && params[existing_dh].blank?
      if params[:diffusion_history_status_id]
        # update the diffusion history status
        dhs = DiffusionHistoryStatus.find(params[:diffusion_history_status_id])
        dhs.update_attributes(status: status, start_time: start_time, end_time: end_time)
      else
        # create a new status.
        DiffusionHistoryStatus.create!(diffusion_history: @dh, status: status, start_time: start_time, end_time: end_time)
      end
    end

    respond_to do |format|
      if params[:diffusion_history_id].blank? && params[:exists].blank?
        params[:created] = true
      end
      params[:reload] = true
      format.js
    end
  end

  def destroy_diffusion_history
    dh = DiffusionHistory.find(params[:diffusion_history_id])
    dh.destroy
    respond_to do |format|
      format.html { redirect_to practice_adoptions_path(dh.practice), notice: 'Adoption entry was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_practice
    id = params[:id] || params[:practice_id]
    @practice = Practice.friendly.find(id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def practice_params
    params.require(:practice).permit(:need_training, :short_name, :tagline, :process, :it_required, :need_new_license, :description, :name, :initiating_facility, :summary, :origin_title, :origin_story, :cost_to_implement_aggregate, :sustainability_aggregate, :veteran_satisfaction_aggregate, :difficulty_aggregate, :date_initiated,
                                     :number_adopted, :number_departments, :number_failed, :implementation_time_estimate, :implementation_time_estimate_description, :implentation_summary, :implentation_fte,
                                     :training_provider, :training_length, :training_test, :training_provider_role, :required_training_summary, :support_network_email,
                                     :initiating_facility_type, :initiating_department_office_id,
                                     :main_display_image, :crop_x, :crop_y, :crop_h, :crop_w,
                                     :delete_main_display_image,
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
                                     practice_problem_resources_attributes: {},
                                     practice_solution_resources_attributes: {},
                                     practice_results_resources_attributes: {},
                                     practice_multimedia_attributes: {},
                                     practice_email: {},
                                     practice_testimonials_attributes: [:id, :_destroy, :testimonial, :author, :position],
                                     practice_awards_attributes: [:id, :_destroy, :name],
                                     categories_attributes: [:id, :_destroy, :name, :is_other],
                                     practice_origin_facilities_attributes: [:id, :_destroy, :facility_id, :facility_type, :initiating_department_office_id],
                                     practice_metrics_attributes: [:id, :_destroy, :description],
                                     practice_emails_attributes: [:id, :address, :_destroy]
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
    # if the user is the practice owner or the user is an admin or approver/editor
    unless @practice.user_id == current_user.id || current_user&.roles.any?
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

  def set_facility_data
    @facility_data = facilities_json.find { |f| f['StationNumber'] == @practice.initiating_facility } if @practice.facility?
  end

  def set_office_data
    practice_department_id = @practice.initiating_department_office_id
    @office_data = origin_data_json['departments'][practice_department_id - 1]['offices'].find { |o| o['id'] == @practice.initiating_facility.to_i } if @practice.department?
  end

  def set_visn_data
    @visn_data = origin_data_json['visns'].find { |v| v['id'] == @practice.initiating_facility.to_i } if @practice.visn?
  end

  def set_initiating_facility_other
    @initiating_facility_other = @practice.initiating_facility if @practice.other?
  end

  def set_office_data
    @office_data = facilities_json.find{|f|f['']}
  end

  def can_view_committed_view
    unless UserPractice.find_by(user: current_user, practice: @practice, committed: true)
      warning = 'You must commit to this practice first!'
      flash[:warning] = warning

      redirect_to(practice_planning_checklist_path(practice_id: @practice.slug), warning: warning)
    end
  end

  def practices_json(practices)
    # practices = Practice.where(approved: true, published: true)
    practices_array = []

    practices.each do |practice|
      practice_hash = JSON.parse(practice.to_json) # convert to hash
      practice_hash['image'] = practice.main_display_image.present? ? practice.main_display_image_s3_presigned_url : ''
      if practice.date_initiated
        practice_hash['date_initiated'] = practice.date_initiated.strftime("%B %Y")
      else
        practice_hash['date_initiated'] = '(start date unknown)'
      end

      if practice.categories&.length > 0
        practice_hash['categories_name'] = []

        practice.categories.each do |category|
          if category.name != 'None'
            practice_hash['categories_name'].push category.name

            unless category.related_terms.empty?
              practice_hash['categories_name'].concat(category.related_terms)
            end
          end
        end
      end

      # display initiating facility
      practice_hash['initiating_facility'] = helpers.origin_display(practice)
      practice_hash['user_favorited'] = current_user.favorite_practice_ids.include?(practice.id) if current_user.present?
      practices_array.push practice_hash
    end

    practices_array.to_json.html_safe
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
    if @practice.name.present? && @practice.initiating_facility_type.present? && @practice.date_initiated.present? && @practice.summary.present? && @practice.support_network_email.present?
      @practice.facility? ? @practice.practice_origin_facilities.present? : @practice.initating_facility.present?
    else
      false
    end
  end
end
