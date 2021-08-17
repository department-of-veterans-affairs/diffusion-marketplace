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
    @facilities_data = VaFacility.cached_va_facilities
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_practice_partner
    @practice_partner = PracticePartner.friendly.find(params[:id])
  end
end
