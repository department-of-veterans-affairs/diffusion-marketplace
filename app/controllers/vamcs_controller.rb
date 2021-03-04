class VamcsController < ApplicationController
  before_action :set_vamc, only: :show
  def index

    @vamcs = Vamc.get_all_vamcs
    @visns = Vamc.get_visns
    @types = []
    all_types = Vamc.get_types
    all_types.each do |t|
      @types << t
    end
    # @vamcs.each do  |v|
    #   @types << v.fy17_parent_station_complexity_level
    # end
    # @types = @types.sort
    # debugger
  end

  def show
  end

  private

  def set_vamc
    @vamc = Vamc.friendly.find(params[:id])
  end

end