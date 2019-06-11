class PracticePartnersController < ApplicationController
  before_action :set_practice_partner, only: [:show, :edit, :update, :destroy]

  # GET /practice_partners
  # GET /practice_partners.json
  def index
    @practice_partners = PracticePartner.all.order(name: :asc)
  end

  # GET /practice_partners/1
  # GET /practice_partners/1.json
  def show
    @facilities_data = facilities_json['features']
  end

  # GET /practice_partners/new
  def new
    @practice_partner = PracticePartner.new
  end

  # GET /practice_partners/1/edit
  def edit
  end

  # POST /practice_partners
  # POST /practice_partners.json
  def create
    @practice_partner = PracticePartner.new(practice_partner_params)

    respond_to do |format|
      if @practice_partner.save
        format.html { redirect_to @practice_partner, notice: 'Strategic sponsor was successfully created.' }
        format.json { render :show, status: :created, location: @practice_partner }
      else
        format.html { render :new }
        format.json { render json: @practice_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practice_partners/1
  # PATCH/PUT /practice_partners/1.json
  def update
    respond_to do |format|
      if @practice_partner.update(practice_partner_params)
        format.html { redirect_to @practice_partner, notice: 'Strategic sponsor was successfully updated.' }
        format.json { render :show, status: :ok, location: @practice_partner }
      else
        format.html { render :edit }
        format.json { render json: @practice_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practice_partners/1
  # DELETE /practice_partners/1.json
  def destroy
    @practice_partner.destroy
    respond_to do |format|
      format.html { redirect_to practice_partners_url, notice: 'Strategic sponsor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice_partner
      @practice_partner = PracticePartner.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_partner_params
      params.require(:practice_partner).permit(:name, :short_name, :description, :position)
    end
end
