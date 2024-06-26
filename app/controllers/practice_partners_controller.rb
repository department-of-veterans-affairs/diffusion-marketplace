class PracticePartnersController < ApplicationController
  before_action :set_practice_partner, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to root_path
  end

  # GET /practice_partners/1
  # GET /practice_partners/1.json
  def show
    # only allow users to view the show page for major practices
    redirect_to root_path unless @practice_partner.is_major

    @facilities_data = VaFacility.cached_va_facilities.order_by_station_name
    @partner_practices = helpers.is_user_a_guest? ? @practice_partner.practices.published_enabled_approved.public_facing.sort_by_retired.sort_a_to_z : @practice_partner.practices.published_enabled_approved.sort_by_retired.sort_a_to_z
    @pagy_partner_practices, @paginated_partner_practices = pagy_array(
      @partner_practices,
      items: 12,
      link_extra: "data-remote='true' class='paginated-partner-practices-page-#{params[:page].present? ? params[:page].to_i + 1 : 2}-link dm-button--outline-secondary margin-top-105 width-15'"
    )
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_practice_partner
    @practice_partner = PracticePartner.cached_practice_partners.friendly.find(params[:id])
  end
end
