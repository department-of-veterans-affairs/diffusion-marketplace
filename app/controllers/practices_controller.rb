class PracticesController < ApplicationController
  before_action :set_practice, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :can_view_practice, only: [:show, :edit, :update, :destroy]

  # GET /practices
  # GET /practices.json
  def index
    @practices = Practice.where(approved: true, published: true)
    @facilities_data = facilities_json['features']
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
    @facility_data = facilities_json['features'].find { |f| f['properties']['id'] == @practice.initiating_facility }
  end

  # GET /practices/new
  def new
    @practice = Practice.new
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
    updated = @practice.update(practice_params)
    if updated
      partner_keys = params[:practice][:practice_partner].keys
      @practice.practice_partner_practices.each do |partner|
        partner.destroy unless partner_keys.include? partner.id.to_s
      end
      partner_keys.each do |key|
        next if @practice.practice_partners.ids.include? key

        @practice.practice_partner_practices.create practice_partner_id: key.to_i
      end

      dept_keys = params[:practice][:practice_department].keys
      @practice.department_practices.each do |partner|
        partner.destroy unless dept_keys.include? partner.id.to_s
      end
      dept_keys.each do |key|
        next if @practice.departments.ids.include? key

        @practice.department_practices.create department_id: key.to_i
      end
    end
    respond_to do |format|
      if updated
        format.html { redirect_to @practice, notice: 'Practice was successfully updated.' }
        format.json { render :show, status: :ok, location: @practice}
      else
        format.html { render :edit }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1
  # DELETE /practices/1.json
  def destroy
    @practice.destroy
    respond_to do |format|
      format.html { redirect_to practices_url, notice: 'Practice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def download_toolkit
  #   send_file(
  #     "#{Rails.root}/public/your_file.pdf",
  #     filename: "your_custom_file_name.pdf",
  #     type: "application/pdf"
  #   )
  # end

  def search
    # practices = Practice.where(approved: true, published: true).select(:id, :name, :short_name, :description, :summary, :initiating_facility, :date_initiated)
    practices = Practice.where(approved: true, published: true)
    practices_array = []

    practices.each do |practice|
      practice_hash = JSON.parse(practice.to_json) # convert to hash
      practice_hash['image'] = practice.main_display_image.url
      if practice.date_initiated
        practice_hash['date_initiated'] = practice.date_initiated.strftime("%B %Y")
      else
        practice_hash['date_initiated'] = '(start date unknown)'
      end

      # display initiating facility
      facility_data = facilities_json['features'].find { |f| f['properties']['id'] == practice.initiating_facility }
      practice_hash['initiating_facility'] = facility_data.present? ? facility_data['properties']['name'] : practice.initiating_facility

      practices_array.push practice_hash
    end

    @practices_json = practices_array.to_json.html_safe
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_practice
    @practice = Practice.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def practice_params
    params.require(:practice).permit(:tagline, :description, :name, :initiating_facility, :summary, :origin_title, :origin_story, :cost_to_implement_aggregate, :veteran_satisfaction_aggregate, :difficulty_aggregate,
                                     :number_adopted, :number_failed, :implementation_time_estimate, :implementation_time_estimate_description, :implentation_summary, :implentation_fte,
                                     :training_provider, :required_training_summary, :support_network_email,
                                     :main_display_image, :main_display_image_original_w, :main_display_image_original_h, :main_display_image_crop_x, :main_display_image_crop_y, :main_display_image_crop_w, :main_display_image_crop_h,
                                     :origin_picture, :origin_picture_original_w, :origin_picture_original_h, :origin_picture_crop_x, :origin_picture_crop_y, :origin_picture_crop_w, :origin_picture_crop_h,
                                     impact_photos_attributes: [:id, :title, :description, :attachment, :attachment_original_w, :attachment_original_h, :attachment_crop_x, :attachment_crop_y,
                                                                :attachment_crop_w, :attachment_crop_h, :_destroy],
                                     difficulties_attributes: [:id, :description, :_destroy],
                                     risk_mitigations_attributes: [:id, :_destroy, risks_attributes: [:id, :description, :_destroy], mitigations_attributes: [:id, :description, :_destroy]],
                                     timelines_attributes: [:id, :description, :_destroy],
                                     va_employees_attributes: [:id, :name, :role, :_destroy, :avatar, :avatar_original_w, :avatar_original_h, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h],
                                     additional_staffs_attributes: [:id, :_destroy, :title, :hours_per_week, :duration_in_weeks, :permanent],
                                     additional_resources_attributes: [:id, :_destroy, :description], required_staff_training: [:id, :_destroy, :title, :description])
  end

  def can_view_practice
    # if practice is published
    unless @practice.published && @practice.approved
      prevent_practice_permissions
    end
  end

  def can_edit_practice
    prevent_practice_permissions
  end

  def prevent_practice_permissions
    # if the user is the practice owner or the user is an admin or approver/editor
    unless @practice.user_id == current_user.id || current_user.roles.any?
      respond_to do |format|
        warning = 'You are not authorized to view this content.'
        flash[:warning] = warning
        format.html {redirect_to '/', warning: warning}
        format.json {render warning: warning}
      end
    end
  end
end
