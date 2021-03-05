class VamcsController < ApplicationController
  before_action :set_vamc, only: :show
  def index
    debugger
    @vamcs = Vamc.get_all_vamcs
    @visns = Vamc.get_visns
    @types = []
    all_types = Vamc.get_types
    all_types.each do |t|
      @types << t
    end
  end

  def show
    debugger
  end

  private

  def set_vamc
    @vamc = Vamc.friendly.find(params[:id])
  end

end