class VamcsController < ApplicationController
  before_action :set_vamc, only: :show
  def index

    @vamcs = Vamc.get_all_vamcs

  end

  def show
  end

  private

  def set_vamc
    @vamc = Vamc.friendly.find(params[:id])
  end

end