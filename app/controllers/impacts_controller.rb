class ImpactsController < ApplicationController
  before_action :set_impact, only: [:show, :edit, :update, :destroy]

  # GET /impacts
  # GET /impacts.json
  def index
    @impacts = Impact.all
  end

  # GET /impacts/1
  # GET /impacts/1.json
  def show
  end

  # GET /impacts/new
  def new
    @impact = Impact.new
  end

  # GET /impacts/1/edit
  def edit
  end

  # POST /impacts
  # POST /impacts.json
  def create
    @impact = Impact.new(impact_params)

    respond_to do |format|
      if @impact.save
        format.html { redirect_to @impact, notice: 'Impact was successfully created.' }
        format.json { render :show, status: :created, location: @impact }
      else
        format.html { render :new }
        format.json { render json: @impact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /impacts/1
  # PATCH/PUT /impacts/1.json
  def update
    respond_to do |format|
      if @impact.update(impact_params)
        format.html { redirect_to @impact, notice: 'Impact was successfully updated.' }
        format.json { render :show, status: :ok, location: @impact }
      else
        format.html { render :edit }
        format.json { render json: @impact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /impacts/1
  # DELETE /impacts/1.json
  def destroy
    @impact.destroy
    respond_to do |format|
      format.html { redirect_to impacts_url, notice: 'Impact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_impact
      @impact = Impact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def impact_params
      params.require(:impact).permit(:name, :short_name, :description, :position, :impact_category)
    end
end
