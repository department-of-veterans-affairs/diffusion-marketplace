class StrategicSponsorsController < ApplicationController
  before_action :set_strategic_sponsor, only: [:show, :edit, :update, :destroy]

  # GET /strategic_sponsors
  # GET /strategic_sponsors.json
  def index
    @strategic_sponsors = StrategicSponsor.all
  end

  # GET /strategic_sponsors/1
  # GET /strategic_sponsors/1.json
  def show
  end

  # GET /strategic_sponsors/new
  def new
    @strategic_sponsor = StrategicSponsor.new
  end

  # GET /strategic_sponsors/1/edit
  def edit
  end

  # POST /strategic_sponsors
  # POST /strategic_sponsors.json
  def create
    @strategic_sponsor = StrategicSponsor.new(strategic_sponsor_params)

    respond_to do |format|
      if @strategic_sponsor.save
        format.html { redirect_to @strategic_sponsor, notice: 'Strategic sponsor was successfully created.' }
        format.json { render :show, status: :created, location: @strategic_sponsor }
      else
        format.html { render :new }
        format.json { render json: @strategic_sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strategic_sponsors/1
  # PATCH/PUT /strategic_sponsors/1.json
  def update
    respond_to do |format|
      if @strategic_sponsor.update(strategic_sponsor_params)
        format.html { redirect_to @strategic_sponsor, notice: 'Strategic sponsor was successfully updated.' }
        format.json { render :show, status: :ok, location: @strategic_sponsor }
      else
        format.html { render :edit }
        format.json { render json: @strategic_sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategic_sponsors/1
  # DELETE /strategic_sponsors/1.json
  def destroy
    @strategic_sponsor.destroy
    respond_to do |format|
      format.html { redirect_to strategic_sponsors_url, notice: 'Strategic sponsor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strategic_sponsor
      @strategic_sponsor = StrategicSponsor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def strategic_sponsor_params
      params.require(:strategic_sponsor).permit(:name, :short_name, :description, :position)
    end
end
