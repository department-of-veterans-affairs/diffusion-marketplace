class VaFacilitiesController < ApplicationController
  before_action :set_va_facility, only: :show
  def index
    @num_recs = params[:more] || "20"
    if params[:sortby].present?
      @facilities = VaFacility.get_all_facilities(params[:sortby])
    else
      @facilities = VaFacility.get_all_facilities
    end

    @visns = VaFacility.get_visns
    @types = []
    all_types = VaFacility.get_types
    all_types.each do |t|
      @types << t
    end
    if params[:asc].present? && params[:asc] == "false"
      @facilities.to_a.reverse
    end


    @filtered_facilities= @facilities
    #check params and filters...
    if params[:facility].present?
      @filtered_facilities = @facilities.select { |x| x["id"] == params[:facility].to_i}
    end
    if params[:visn].present?
      @filtered_facilities = @filtered_facilities.select { |x| x["visn_number"] == params[:visn].to_i}
    end
    if params[:type].present?
      @filtered_facilities = @filtered_facilities.select { |x| x["fy17_parent_station_complexity_level"].include? params[:type].to_s}
    end
    @results_count = @filtered_facilities.count

    if @filtered_facilities.count > @num_recs.to_i
      @filtered_facilities = @filtered_facilities.take(@num_recs.to_i)
    end


  end

  def show
    @num_practice_recs = params[:practices] || "3"
    @created_practices = VaFacility.get_practices_created_by_facility(@va_facility.station_number)
    @practice_results_count = @created_practices.count

    @created_practices = @created_practices.take(@num_practice_recs.to_i)
    @created_practices_count = @created_practices.count
    @adoptions = VaFacility.get_adoptions_by_facility(@va_facility.station_number)
    @adoptions_count = @adoptions.count
    @categories = VaFacility.get_categories
    #google maps implementation
    @va_facility_marker = Gmaps4rails.build_markers(@va_facility) do |facility, marker|

      marker.lat facility.latitude
      marker.lng facility.longitude
      marker.picture({
                         url: view_context.image_path('visn-va-facility-map-marker-default.svg'),
                         width: 34,
                         height: 46,
                         scaledWidth: 34,
                         scaledHeight: 46
                     })
      marker.shadow nil
      marker.json({ id: facility.id })
    end
  end

  private

  def set_va_facility
    @va_facility = VaFacility.friendly.find(params[:id])
  end

end