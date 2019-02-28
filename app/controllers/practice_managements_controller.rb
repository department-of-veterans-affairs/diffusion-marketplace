class PracticeManagementsController < ApplicationController
  before_action :set_area_of_affect, only: [:show, :edit, :update, :destroy]

  # GET /area_of_affects
  # GET /area_of_affects.json
  def index
    @practice_managements = PracticeManagement.all
  end

  # GET /area_of_affects/1
  # GET /area_of_affects/1.json
  def show
  end

  # GET /area_of_affects/new
  def new
    @practice_management = PracticeManagement.new
  end

  # GET /area_of_affects/1/edit
  def edit
  end

  # POST /area_of_affects
  # POST /area_of_affects.json
  def create
    @practice_management = PracticeManagement.new(area_of_affect_params)

    respond_to do |format|
      if @practice_management.save
        format.html { redirect_to @practice_management, notice: 'Area of affect was successfully created.' }
        format.json { render :show, status: :created, location: @practice_management }
      else
        format.html { render :new }
        format.json { render json: @practice_management.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /area_of_affects/1
  # PATCH/PUT /area_of_affects/1.json
  def update
    respond_to do |format|
      if @practice_management.update(area_of_affect_params)
        format.html { redirect_to @practice_management, notice: 'Area of affect was successfully updated.' }
        format.json { render :show, status: :ok, location: @practice_management }
      else
        format.html { render :edit }
        format.json { render json: @practice_management.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /area_of_affects/1
  # DELETE /area_of_affects/1.json
  def destroy
    @practice_management.destroy
    respond_to do |format|
      format.html { redirect_to area_of_affects_url, notice: 'Area of affect was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area_of_affect
      @practice_management = PracticeManagement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_of_affect_params
      params.require(:practice_management).permit(:name, :short_name, :description, :position)
    end
end
