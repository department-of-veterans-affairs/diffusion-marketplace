class PracticesController < ApplicationController
  before_action :set_practice, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :can_view_practice, only: [:show, :edit, :update, :destroy]

  # GET /practices
  # GET /practices.json
  def index
    @practices = Practice.where(approved: true, published: true)
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
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
    respond_to do |format|
      if @practice.update(practice_params)
        format.html { redirect_to @practice, notice: 'Practice was successfully updated.' }
        format.json { render :show, status: :ok, location: @practice }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_params
      params.require(:practice).permit(:name, :short_name, :description, :position, :is_vha_field, :is_program_office, :vha_visn, :medical_center, :business_case_summary, :support_network_email, :va_pulse_link, :additional_notes)
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
        format.html { redirect_to '/', warning: warning }
        format.json { render warning: warning }
      end
    end
  end
end
