class VisnsController < ApplicationController
  include PracticeUtils
  before_action :set_visn, only: [:show, :load_facilities_show_rows]

  def index
    @visns = Visn.cached_visns
    @visns_counts = set_visns_counts
    @visn_markers = Gmaps4rails.build_markers(@visns) do |visn, marker|
      marker.lat visn[:latitude].to_s
      marker.lng visn[:longitude].to_s

      marker.picture({
                       url: view_context.image_path('visn-va-facility-map-marker-default.svg'),
                       width: 48,
                       height: 64,
                       scaledWidth: 48,
                       scaledHeight: 64
                     })

      marker.shadow nil
      marker.json({
        id: visn[:id],
        number: visn[:number]
      })

      marker.infowindow render_to_string(partial: 'visns/maps/index_infowindow', locals: { visn: visn })
    end
  end

  def show
    @primary_visn_liaison = VisnLiaison.find_by(visn: @visn, primary: true)
    @visn_va_facilities = VaFacility.get_by_visn(@visn).select(:common_name, :id, :official_station_name, :latitude, :longitude, :classification, :slug, :station_number)

    @visn_va_facility_markers = Gmaps4rails.build_markers(@visn_va_facilities) do |facility, marker|
      marker.lat facility[:latitude].to_s
      marker.lng facility[:longitude].to_s

      marker.picture({
                       url: view_context.image_path('visn-va-facility-map-marker-default.svg'),
                       width: 34,
                       height: 46,
                       scaledWidth: 34,
                       scaledHeight: 46
                     })

      marker.shadow nil
      marker.json({
        id: facility.id,
        type: facility.classification
      })

      marker.infowindow render_to_string(partial: 'visns/maps/show_infowindow', locals: { va_facility: facility })
    end

    # set '@practices_json' to avoid js console error when utilizing the practices/search.js.erb file
    @practices_json = []
    visn_va_facilities_ids = @visn_va_facilities.get_ids
    @practices_created_by_visn = @visn.get_created_practices(visn_va_facilities_ids)
    @practices_created_json = practices_json(@practices_created_by_visn)
    # get the unique categories for practices created in a VISN
    @practices_created_categories = []
    get_categories_by_practices(@practices_created_by_visn, @practices_created_categories)

    @practices_adopted_by_visn = @visn.get_adopted_practices(visn_va_facilities_ids)
    @practices_adopted_json = practices_json(@practices_adopted_by_visn)
    # get the unique categories for practices adopted in a VISN
    @practices_adopted_categories = []
    get_categories_by_practices(@practices_adopted_by_visn, @practices_adopted_categories)
  end

  def load_facilities_show_rows
    @facilities = VaFacility.get_by_visn(@visn).select(:common_name, :id, :official_station_name, :slug, :station_number, :fy17_parent_station_complexity_level)

    table_rows_html = render_to_string('visns/_show_table_row', layout: false, locals: { facilities: @facilities })

    respond_to do |format|
      format.html
      format.json { render :json => { rowsHtml: table_rows_html, count: @facilities.length } }
    end
  end

  private

  def set_visn
    # use find_by! in order to throw an exception if a visn with the number param does not exist
    @visn = Visn.find_by!(number: params[:number])
  end

  def set_visns_counts
    visn_counts = []
    @visns.each do |visn|
      va_facility_ids = VaFacility.get_by_visn(visn).get_ids
      created = visn.get_created_practices(va_facility_ids).size
      adopted = visn.get_adopted_practices(va_facility_ids).size
      visn_counts.push({number: visn[:number], created: created, adopted: adopted})
    end
    visn_counts
  end
end
