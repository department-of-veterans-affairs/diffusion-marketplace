class AncillaryServicesController < ApplicationController
  before_action :set_ancillary_service, only: [:show, :edit, :update, :destroy]

  # GET /ancillary_services
  # GET /ancillary_services.json
  def index
    @ancillary_services = AncillaryService.all
  end

  # GET /ancillary_services/1
  # GET /ancillary_services/1.json
  def show
  end

  # GET /ancillary_services/new
  def new
    @ancillary_service = AncillaryService.new
  end

  # GET /ancillary_services/1/edit
  def edit
  end

  # POST /ancillary_services
  # POST /ancillary_services.json
  def create
    @ancillary_service = AncillaryService.new(ancillary_service_params)

    respond_to do |format|
      if @ancillary_service.save
        format.html { redirect_to @ancillary_service, notice: 'Ancillary service was successfully created.' }
        format.json { render :show, status: :created, location: @ancillary_service }
      else
        format.html { render :new }
        format.json { render json: @ancillary_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ancillary_services/1
  # PATCH/PUT /ancillary_services/1.json
  def update
    respond_to do |format|
      if @ancillary_service.update(ancillary_service_params)
        format.html { redirect_to @ancillary_service, notice: 'Ancillary service was successfully updated.' }
        format.json { render :show, status: :ok, location: @ancillary_service }
      else
        format.html { render :edit }
        format.json { render json: @ancillary_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ancillary_services/1
  # DELETE /ancillary_services/1.json
  def destroy
    @ancillary_service.destroy
    respond_to do |format|
      format.html { redirect_to ancillary_services_url, notice: 'Ancillary service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ancillary_service
      @ancillary_service = AncillaryService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ancillary_service_params
      params.require(:ancillary_service).permit(:name, :short_name, :description, :position)
    end
end
