class PracticePartnersController < ApplicationController
  before_action :set_practice_partner, only: [:show, :edit, :update, :destroy]

  # GET /practice_partners
  # GET /practice_partners.json
  def index
    @practice_partners = PracticePartner.cached_practice_partners.order(name: :asc)
  end

  # GET /practice_partners/1
  # GET /practice_partners/1.json
  def show
    @facilities_data = VaFacility.cached_va_facilities.order_by_station_name
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_practice_partner
    @practice_partner = PracticePartner.cached_practice_partners.friendly.find(params[:id])
  end
end
