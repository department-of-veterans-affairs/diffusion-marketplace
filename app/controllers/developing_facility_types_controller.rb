class DevelopingFacilityTypesController < ApplicationController
  before_action :set_developing_facility_type, only: [:show, :edit, :update, :destroy]

  # GET /developing_facility_types
  # GET /developing_facility_types.json
  def index
    @developing_facility_types = DevelopingFacilityType.all
  end

  # GET /developing_facility_types/1
  # GET /developing_facility_types/1.json
  def show
  end

  # GET /developing_facility_types/new
  def new
    @developing_facility_type = DevelopingFacilityType.new
  end

  # GET /developing_facility_types/1/edit
  def edit
  end

  # POST /developing_facility_types
  # POST /developing_facility_types.json
  def create
    @developing_facility_type = DevelopingFacilityType.new(developing_facility_type_params)

    respond_to do |format|
      if @developing_facility_type.save
        format.html { redirect_to @developing_facility_type, notice: 'Developing facility type was successfully created.' }
        format.json { render :show, status: :created, location: @developing_facility_type }
      else
        format.html { render :new }
        format.json { render json: @developing_facility_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /developing_facility_types/1
  # PATCH/PUT /developing_facility_types/1.json
  def update
    respond_to do |format|
      if @developing_facility_type.update(developing_facility_type_params)
        format.html { redirect_to @developing_facility_type, notice: 'Developing facility type was successfully updated.' }
        format.json { render :show, status: :ok, location: @developing_facility_type }
      else
        format.html { render :edit }
        format.json { render json: @developing_facility_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /developing_facility_types/1
  # DELETE /developing_facility_types/1.json
  def destroy
    @developing_facility_type.destroy
    respond_to do |format|
      format.html { redirect_to developing_facility_types_url, notice: 'Developing facility type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_developing_facility_type
      @developing_facility_type = DevelopingFacilityType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def developing_facility_type_params
      params.require(:developing_facility_type).permit(:name, :short_name, :position, :description)
    end
end
