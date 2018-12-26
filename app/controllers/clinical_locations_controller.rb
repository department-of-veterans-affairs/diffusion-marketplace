class ClinicalLocationsController < ApplicationController
  before_action :set_clinical_location, only: [:show, :edit, :update, :destroy]

  # GET /clinical_locations
  # GET /clinical_locations.json
  def index
    @clinical_locations = ClinicalLocation.all
  end

  # GET /clinical_locations/1
  # GET /clinical_locations/1.json
  def show
  end

  # GET /clinical_locations/new
  def new
    @clinical_location = ClinicalLocation.new
  end

  # GET /clinical_locations/1/edit
  def edit
  end

  # POST /clinical_locations
  # POST /clinical_locations.json
  def create
    @clinical_location = ClinicalLocation.new(clinical_location_params)

    respond_to do |format|
      if @clinical_location.save
        format.html { redirect_to @clinical_location, notice: 'Clinical location was successfully created.' }
        format.json { render :show, status: :created, location: @clinical_location }
      else
        format.html { render :new }
        format.json { render json: @clinical_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clinical_locations/1
  # PATCH/PUT /clinical_locations/1.json
  def update
    respond_to do |format|
      if @clinical_location.update(clinical_location_params)
        format.html { redirect_to @clinical_location, notice: 'Clinical location was successfully updated.' }
        format.json { render :show, status: :ok, location: @clinical_location }
      else
        format.html { render :edit }
        format.json { render json: @clinical_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clinical_locations/1
  # DELETE /clinical_locations/1.json
  def destroy
    @clinical_location.destroy
    respond_to do |format|
      format.html { redirect_to clinical_locations_url, notice: 'Clinical location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clinical_location
      @clinical_location = ClinicalLocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clinical_location_params
      params.require(:clinical_location).permit(:name, :short_name, :description, :position)
    end
end
