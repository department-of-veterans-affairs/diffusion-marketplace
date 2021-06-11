class VaFacilitiesController < ApplicationController
  include PracticeUtils
  before_action :set_va_facility, only: [:show, :created_practices, :update_practices_adopted_at_facility]

  def index
    @facilities = VaFacility.cached_va_facilities.select(:common_name, :fy17_parent_station_complexity_level, :id, :official_station_name, :slug, :station_number, :street_address_state, :visn_id).order(:official_station_name).includes(:visn)
    @visns = Visn.cached_visns
    @types = VaFacility.cached_va_facilities.get_complexity
    @filtered_facilities = @facilities
    @selected_facility
    #check params and filters...
    if params[:facility].present?
      @filtered_facilities = [@facilities.find(params[:facility])]
      @selected_facility = params[:facility].to_i
    end
    if params[:type].present?
      @filtered_facilities = @filtered_facilities.where(fy17_parent_station_complexity_level: params[:type].to_s)
    end
    if params[:visn].present?
      @filtered_facilities = @filtered_facilities.select { |x| x.visn.number == params[:visn].to_i}
    end

    @filtered_facilities_count = @filtered_facilities.size
  end

  def show
    station_number = @va_facility.station_number
    @num_practice_recs = params[:practices] || "3"
    @adoptions_at_facility = Practice.get_facility_adopted_practices(@va_facility.station_number)
    @adopted_practices_categories = get_categories_by_practices(@adoptions_at_facility, [])
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
    created_practices = Practice.get_facility_created_practices(station_number, nil, 'a_to_z', nil)
    @pagy_created_practices = pagy_array(
      created_practices,
      items: 3
    )
    @pagy_created_info = @pagy_created_practices[0]
    @created_practices = @pagy_created_practices[1]

    @created_pr_count = created_practices.size
    @created_practices_categories = get_categories_by_practices(created_practices, [])
  end

  # GET /facilities/:id/created_practices
  def created_practices
    station_number = @va_facility.station_number
    page = 1
    page = params[:page].to_i if params[:page].present?
    sort_option = params[:sort_option] || 'a_to_z'
    search_term = params[:search_term] ? params[:search_term].downcase : nil
    categories = params[:categories] || nil

    created_practices = Practice.get_facility_created_practices(station_number, search_term, sort_option, categories)
    @pagy_created_practices = pagy_array(
      created_practices,
      items: 3,
      page: page
    )
    @pagy_created_info = @pagy_created_practices[0]
    practices = @pagy_created_practices[1]
    practice_cards_html = ''
    practices.each do |pr|
      pr_html = render_to_string('shared/_practice_card', layout: false, locals: { practice: pr })
      practice_cards_html += pr_html
    end

    respond_to do |format|
      format.html
      format.json { render :json => { practice_cards_html: practice_cards_html, count: created_practices.size, next: @pagy_created_info.next } }
    end
  end

  def update_practices_adopted_at_facility
    selected_cat = params["selected_category"].present? ?  params["selected_category"] : nil
    key_word = params["key_word"]
    @adoptions_at_facility = Practice.get_facility_adopted_practices(@va_facility.station_number, key_word, selected_cat)
    adopted_facility_results_html = ''
    @adoptions_at_facility.each do |pr|
      pr_html = render_to_string('va_facilities/_adopted_facility_table_row', layout: false, locals: { ad: pr })
      adopted_facility_results_html += pr_html
    end

    respond_to do |format|
      format.html
      format.json { render :json => {adopted_facility_results_html: adopted_facility_results_html, count: @adoptions_at_facility.size } }
    end
  end

  private

  def set_va_facility
    @va_facility = VaFacility.friendly.find(params[:id])
  end
end
