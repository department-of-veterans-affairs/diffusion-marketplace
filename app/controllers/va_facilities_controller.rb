class VaFacilitiesController < ApplicationController
  before_action :set_va_facility, only: [:show, :created_practices]
  before_action :authenticate_user!

  def index
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
    @selected_facility
    #check params and filters...
    if params[:facility].present?
      @filtered_facilities = @facilities.select { |x| x["id"] == params[:facility].to_i}
      @selected_facility = params[:facility].to_i
    end
    if params[:visn].present?
      @filtered_facilities = @filtered_facilities.select { |x| x["visn_number"] == params[:visn].to_i}
    end
    if params[:type].present?
      @filtered_facilities = @filtered_facilities.select { |x| x["fy17_parent_station_complexity_level"].include? params[:type].to_s}
    end
    @results_count = @filtered_facilities.count
  end

  def show
    station_number = @va_facility.station_number
    @num_practice_recs = params[:practices] || "3"
    @adoptions_at_facility = VaFacility.get_adoptions_by_facility(@va_facility.station_number)
    @adoptions = DiffusionHistory.get_adoptions_by_facility(station_number)
    @categories = Category.with_practices
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

  def update_practices_adopted_at_facility
    selected_cat = params["selected_category"]
    key_word = params["key_word"]
    station_number = params["station_number"]
    if selected_cat.blank? && key_word.blank?
      @adoptions_at_facility = VaFacility.get_adoptions_by_facility(station_number)
    elsif !selected_cat.blank? && key_word.blank?
      @adoptions_at_facility = VaFacility.get_adoptions_by_facility_and_category(station_number, selected_cat)
    elsif !key_word.blank? && selected_cat.blank?
      @adoptions_at_facility = VaFacility.get_adoptions_by_facility_and_keyword(station_number, key_word)
    elsif !selected_cat.blank? && !key_word.blank?
      @adoptions_at_facility = VaFacility.get_adoptions_by_facility_category_and_keyword(station_number, selected_cat, key_word)
    end
    data = rewrite_practices_adopted_at_this_facility_filtered_by_category(@adoptions_at_facility, @total_adoptions_for_practice)
    results = []
    results << data
    result_count =  @adoptions_at_facility.count.to_s + " result"
      if @adoptions_at_facility.count != 1
        result_count += "s"
      end
    result_count += ":"
    results << result_count
    render :json => results
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

  def rewrite_practices_adopted_at_this_facility_filtered_by_category(adoptions_at_facility, total_adoptions_for_practice)
    ret_val = ""
    if adoptions_at_facility.count > 0
      adoptions_at_facility.each do |ad|
        if ad["start_time"].blank?
          start_date = ""
          start_date_tm = ""
        else
          start_date = ad["start_time"].to_date.strftime("%-d %B %Y")
          start_date_tm = ad["start_time"].to_date.strftime("%Y/%m/%d")
        end
        ret_val += '<tr>'
        ret_val += '<th class="bg-gray-2 grid-col-5" scope="row" role="rowheader">'
        ret_val += '<a class="dm-internal-link" href="/practices/' + ad["slug"] + '"> ' + ad["name"] + '</a> '
        ret_val += '<a title="Bookmark ' + ad["name"] + '" aria-label="' + ad["name"] + '" tabindex="-1" aria-hidden="true" class="dm-practice-bookmark-btn" id="dm-bookmark-button-' + ad["id"].to_s + '" data-remote="true" rel="nofollow" data-method="post" href="/practices/' + ad["slug"] + '/favorite.js"> '
        if current_user.favorite_practice_ids.include?(ad["id"])
          ret_val += '<i class="fas fa-bookmark dm-favorite-icon-' + ad["id"].to_s + '"></i>'
        else
          ret_val += '<i class="far fa-bookmark dm-favorite-icon-' + ad["id"].to_s + '"></i>'
        end
        ret_val += '</a>'
        ret_val += '<br />' + ad["summary"] + '</th>'
        status = ad["status"] == "Completed" ? "Successful" : ad["status"]
        ret_val += '<td class="bg-gray-2 grid-col-3" data-sort-value='  + status + '>' + status + '</td>'
        ret_val += '<td class="bg-gray-2 grid-col-2" data-sort-value='  + start_date_tm + '>' + start_date + '</td>'
        ret_val += '<td class="bg-gray-2 grid-col-2" data-sort-value='  + ad["adoptions"].to_s + '>' + ad["adoptions"].to_s + '</td>'
        ret_val += '</tr>'
      end
    end
    ret_val
  end
end
