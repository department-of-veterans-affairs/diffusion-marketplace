class VaFacilitiesController < ApplicationController
  before_action :set_va_facility, only: [:show, :created_practices]
  def index
    @num_recs = params[:more] || "20"
    if params[:sortby].present?
      @facilities = VaFacility.get_all_facilities(params[:sortby])
    else
      @facilities = VaFacility.get_all_facilities
    end

    @visns = Visn.order_by_number
    @types = []
    all_types = VaFacility.get_types
    all_types.each do |t|
      @types << t
    end

    if params[:asc].present? && params[:asc] == "false"
      @facilities = @facilities.to_a.reverse
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
    station_number = @va_facility.station_number
    @num_practice_recs = params[:practices] || "3"
    @adoptions = DiffusionHistory.get_adoptions_by_facility(station_number)
    @adoptions_count = @adoptions.count
    @categories = Category.order_by_name
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

    @created_pr_count = created_practices.count
    @created_practices_categories = get_created_practices_categories(created_practices)
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
      format.json { render :json => { practice_cards_html: practice_cards_html, count: created_practices.length, next: @pagy_created_info.next } }
    end
  end

  private

  def set_va_facility
    @va_facility = VaFacility.friendly.find(params[:id])
  end

  def get_created_practices_categories(practices_array)
    created_pr_categories =  []
    practices_array.each do |pr|
      categories = pr.categories
      categories.each do |cat|
        unless cat.is_other || cat.name === 'None' || cat.name === 'Other'
          category = {id: cat.id, name: cat.name}
          unless created_pr_categories.include?(category)
            created_pr_categories.push(category)
          end
        end
      end
    end
    return created_pr_categories.sort_by! { |k| k[:name].downcase.strip }
  end
end
