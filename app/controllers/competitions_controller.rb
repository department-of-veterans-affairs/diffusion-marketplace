class CompetitionsController < ApplicationController
  before_action :set_facility_data, only: [:shark_tank, :go_fish]

  def shark_tank
    redirect_to root_path
  end

  def go_fish
    redirect_to root_path
  end

  private

  def set_facility_data
    @facilities_data = VaFacility.cached_va_facilities.get_relevant_attributes.order_by_station_name
  end
end