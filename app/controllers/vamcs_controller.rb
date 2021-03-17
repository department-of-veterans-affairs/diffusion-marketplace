class VamcsController < ApplicationController
  before_action :set_vamc, only: :show
  def index
    @num_recs = params[:more] || "20"
    if params[:sortby].present?
      @vamcs = Vamc.get_all_vamcs(params[:sortby])
    else
      @vamcs = Vamc.get_all_vamcs
    end

    @visns = Vamc.get_visns
    @types = []
    all_types = Vamc.get_types
    all_types.each do |t|
      @types << t
    end
    if params[:asc].present? && params[:asc] == "false"
      @vamcs = @vamcs.to_a.reverse
    end


    @filtered_vamcs= @vamcs
    #check params and filters...
    if params[:vamc].present?
      @filtered_vamcs = @vamcs.select { |x| x["id"] == params[:vamc].to_i}
    end
    if params[:visn].present?
      @filtered_vamcs = @filtered_vamcs.select { |x| x["visn_number"] == params[:visn].to_i}
    end
    if params[:type].present?
      @filtered_vamcs = @filtered_vamcs.select { |x| x["fy17_parent_station_complexity_level"].include? params[:type].to_s}
    end
    @results_count = @filtered_vamcs.count

    if @filtered_vamcs.count > @num_recs.to_i
      @filtered_vamcs = @filtered_vamcs.take(@num_recs.to_i)
    end


  end

  def show
    @num_practice_recs = params[:practices] || "3"
    @created_practices = Vamc.get_practices_created_by_vamc(@vamc.station_number)
    @practice_results_count = @created_practices.count

    @created_practices = @created_practices.take(@num_practice_recs.to_i)
    @created_practices_count = @created_practices.count
    @adoptions = Vamc.get_adoptions_by_vamc(@vamc.station_number)
    @adoptions_count = @adoptions.count
    @categories = Vamc.get_categories
  end


  private

  def set_vamc
    @vamc = Vamc.friendly.find(params[:id])
  end

end