class PracticesController < ApplicationController
  before_action :set_practice, only: [:show, :edit, :update, :destroy, :planning_checklist, :commit, :committed, :highlight, :un_highlight, :feature, :un_feature, :favorite, :instructions, :overview, :origin, :collaborators, :impact, :resources, :documentation, :complexity, :timeline, :risk_and_mitigation, :contact, :checklist, :publication_validation]
  before_action :set_facility_data, only: [:show, :planning_checklist]
  before_action :authenticate_user!, except: [:show, :search, :index]
  before_action :can_view_committed_view, only: [:committed]
  before_action :can_view_practice, only: [:show, :edit, :update, :destroy, :planning_checklist]
  before_action :can_create_practice, only: [:new, :create]
  before_action :can_edit_practice, only: [:edit, :update]

  # GET /practices
  # GET /practices.json
  def index
    # @practices = Practice.where(approved: true, published: true).order(name: :asc)
    # @facilities_data = facilities_json['features']
    redirect_to root_path
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

      facility = @vamc_facilities.find {|f| f['StationNumber'] == dhg[0]}
      marker.lat facility['Latitude']
      marker.lng facility['Longitude']

      current_diffusion_status = dhg[1][0].diffusion_history_statuses.find_by(end_time: nil)
      marker_url = view_context.image_path('map-marker-default.svg')
      status = 'Complete'
      if current_diffusion_status.status == 'In progress' || current_diffusion_status.status == 'Planning' || current_diffusion_status.status == 'Implementing'
        marker_url = view_context.image_path('map-marker-in-progress.svg')
        status = 'In progress'
      elsif current_diffusion_status.status == 'Unsuccessful'
        marker_url = view_context.image_path('map-marker-unsuccessful.svg')
        status = 'Unsuccessful'
      end

      marker.picture({
                         url: marker_url,
                         width: 31,
                         height: 44
                     })

      marker.shadow nil
      completed = 0
      in_progress = 0
      unsuccessful = 0
      dhg[1].each do |dh|
        dh_status = dh.diffusion_history_statuses.where(end_time: nil).first
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
        format.html {redirect_to @practice, notice: 'Practice was successfully created.'}
        format.json {render :show, status: :created, location: @practice}
      else
        format.html {render :new}
        format.json {render json: @practice.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    strong_params = practice_params
    updated = @practice.update(strong_params)
    if updated
      partner_keys = []
      partner_keys = params[:practice][:practice_partner].keys if params[:practice][:practice_partner].present?
      @practice.practice_partner_practices.each do |partner|
        partner.destroy unless partner_keys.include? partner.practice_partner_id.to_s
      end

      # Remove impact photo
      if params[:practice][:impact_photos_attributes].present?
        params[:practice][:impact_photos_attributes].each do |key, photo|
          if photo['delete_attachment'] == 'true'
            
            @practice.impact_photos.find(photo[:id]).update_attributes(attachment: nil)
          end
        end
      end

      # Remove VA employee avatar
      if params[:practice][:va_employees_attributes].present?
        params[:practice][:va_employees_attributes].each do |key, e|
          if e['delete_avatar'] == 'true'
            
            @practice.va_employees.find(e[:id]).update_attributes(avatar: nil)
          end
        end
      end

      # Remove practice creator avatar
      if params[:practice][:practice_creators_attributes].present?
        params[:practice][:practice_creators_attributes].each do |key, pc|
          if pc['delete_avatar'] == 'true'
            
            @practice.practice_creators.find(pc[:id]).update_attributes(avatar: nil)
          end
        end
      end

      # Remove additional document file
      if params[:practice][:additional_documents_attributes].present?
        params[:practice][:additional_documents_attributes].each do |key, ad|
          if ad['delete_attachment'] == 'true'
            
            @practice.additional_documents.find(ad[:id]).update_attributes(attachment: nil)
          end
        end
      end
      
      partner_keys.each do |key|
        next if @practice.practice_partners.ids.include? key.to_i

        @practice.practice_partner_practices.create practice_partner_id: key.to_i
      end

      dept_keys = []
      dept_keys = params[:practice][:department].keys if params[:practice][:department].present?
      @practice.department_practices.each do |department|
        department.destroy unless dept_keys.include? department.department_id.to_s
      end
      dept_keys.each do |key|
        next if @practice.departments.ids.include? key.to_i

        @practice.department_practices.create department_id: key.to_i
      end
    end

    respond_to do |format|
      if updated
        format.html {redirect_back fallback_location: root_path, notice: 'Practice was successfully updated.'}
        format.json {render :show, status: :ok, location: @practice}
      else
        format.html {render :edit}
        format.json {render json: @practice.errors, status: :unprocessable_entity}
      end
    end
  end

  def search
    ahoy.track "Practice search", {search_term: request.params[:query]} if request.params[:query].present?
    @practices = Practice.where(approved: true, published: true).order(name: :asc)
    @facilities_data = facilities_json
    @practices_json = practices_json(@practices)
  end

  def planning_checklist
    @facilities_data = facilities_json['features']
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
      PracticeMailer.commitment_response_email(user: current_user, practice: @practice).deliver_now
      PracticeMailer.support_team_notification_of_commitment(user: current_user, practice: @practice).deliver_now
    end

    respond_to do |format|
      if user_practice.save
        format.html {redirect_to practice_committed_path(practice_id: @practice.slug), notice: flash[:notice]} if flash[:notice].present?
        format.html {redirect_to practice_committed_path(practice_id: @practice.slug)} if flash[:notice].blank?
        format.json {render :show, status: :created, location: practice_committed_path}
      else
        format.html {render :planning_checklist, error: user_practice.errors}
        format.json {render json: user_practice.errors, status: :unprocessable_entity}
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
      user_practice = UserPractice.new(user: current_user, practice: @practice, favorited: true)
    end

    @favorited = user_practice.favorited

    respond_to do |format|
      if user_practice.save
        format.js
        format.json {render json: {favorited: user_practice.favorited}, status: :success}
      else
        format.js {redirect_back fallback_location: root_path, error: user_practice.errors}
        format.json {render json: user_practice.errors, status: :unprocessable_entity}
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
  end

  # /practices/slug/collaborators
  def collaborators
  end

  # /practices/slug/overview
  def overview
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

  # /practices/slug/complexity
  def complexity
  end

  # /practices/slug/timeline
  def timeline
  end

  # /practices/slug/risk_and_mitigation
  def risk_and_mitigation
  end

  # /practices/slug/contact
  def contact
  end

  # /practices/slug/checklist
  def checklist
  end

  def published
  end

  def publication_validation
    respond_to do |format|
      if @practice.origin_story
        flash[:notice] = "#{@practice.name} has been successfully published to the Diffusion Marketplace"
        # format.html { redirect_to practice_path(@practice), notice: flash[:notice] }
        format.js {render js: "window.location='#{practice_path(@practice)}'"}
      else
        format.js
      end
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
    params.require(:practice).permit(:need_training, :tagline, :process, :it_required, :need_new_license, :description, :name, :initiating_facility, :summary, :origin_title, :origin_story, :cost_to_implement_aggregate, :sustainability_aggregate, :veteran_satisfaction_aggregate, :difficulty_aggregate,
                                     :number_adopted, :number_departments, :number_failed, :implementation_time_estimate, :implementation_time_estimate_description, :implentation_summary, :implentation_fte,
                                     :training_provider, :training_provider_role, :required_training_summary, :support_network_email,
                                     :main_display_image, :main_display_image_original_w, :main_display_image_original_h, :main_display_image_crop_x, :main_display_image_crop_y, :main_display_image_crop_w, :main_display_image_crop_h,
                                     :origin_picture, :origin_picture_original_w, :origin_picture_original_h, :origin_picture_crop_x, :origin_picture_crop_y, :origin_picture_crop_w, :origin_picture_crop_h,
                                     impact_photos_attributes: [:id, :title, :description, :attachment, :attachment_original_w, :attachment_original_h, :attachment_crop_x, :attachment_crop_y,
                                                                :attachment_crop_w, :attachment_crop_h, :_destroy],
                                     difficulties_attributes: [:id, :description, :_destroy],
                                     risk_mitigations_attributes: [:id, :_destroy, :position, risks_attributes: [:id, :description, :_destroy], mitigations_attributes: [:id, :description, :_destroy]],
                                     timelines_attributes: [:id, :description, :timeline, :milestone, :_destroy, :position],
                                     va_employees_attributes: [:id, :name, :role, :position, :_destroy, :avatar, :avatar_original_w, :avatar_original_h, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h],
                                     additional_staffs_attributes: [:id, :_destroy, :title, :hours_per_week, :duration_in_weeks, :permanent],
                                     additional_resources_attributes: [:id, :_destroy, :description], required_staff_trainings_attributes: [:id, :_destroy, :title, :description], practice_creators_attributes: [:id, :_destroy, :name, :role, :avatar, :position],
                                     publications_attributes: [:id, :_destroy, :title, :link, :position], additional_documents_attributes: [:id, :_destroy, :attachment, :title, :position])
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
    unless @practice.user_id == current_user.id || current_user.roles.any?
      unauthorized_response
    end
  end

  def unauthorized_response
    respond_to do |format|
      warning = 'You are not authorized to view this content.'
      flash[:warning] = warning
      format.html {redirect_to '/', warning: warning}
      format.json {render warning: warning}
    end
  end

  def set_facility_data
    @facility_data = facilities_json.find {|f| f['StationNumber'] == @practice.initiating_facility}
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
      practice_hash['sponsored_practice'] = practice.practice_partners.any?
      if practice.date_initiated
        practice_hash['date_initiated'] = practice.date_initiated.strftime("%B %Y")
      else
        practice_hash['date_initiated'] = '(start date unknown)'
      end

      # display initiating facility
      practice_hash['initiating_facility'] = helpers.facility_name(practice.initiating_facility, facilities_json)
      practice_hash['user_favorited'] = current_user.favorite_practice_ids.include?(practice.id) if current_user.present?
      practices_array.push practice_hash
    end

    practices_array.to_json.html_safe
  end
end
