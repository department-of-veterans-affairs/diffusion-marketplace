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
    @filtered_vamcs= @vamcs
    #check params and filters...
    if params[:vamc].present?
      @filtered_vamcs = @vamcs.where(id: params[:vamc].to_i)
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