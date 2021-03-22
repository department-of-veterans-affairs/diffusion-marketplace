class VaFacilitiesController < ApplicationController
  before_action :set_va_facility, only: :show
  def index
  end

  def show
  end

  private

  def set_va_facility
    @va_facility = VaFacility.friendly.find(params[:id])
  end

end