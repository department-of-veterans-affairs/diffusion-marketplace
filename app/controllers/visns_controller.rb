class VisnsController < ApplicationController
  include PracticeUtils
  before_action :set_visn, only: :show

  def index
    @visns = Visn.cached_visns

    @visn_markers = Gmaps4rails.build_markers(@visns) do |visn, marker|

      current_visn = @visns.find { |vc| vc[:number] == visn.number }

      marker.lat current_visn[:latitude].to_s
      marker.lng current_visn[:longitude].to_s

      marker.picture({
                       url: view_context.image_path('visn-va-facility-map-marker-default.svg'),
                       width: 48,
                       height: 64,
                       scaledWidth: 48,
                       scaledHeight: 64
                     })

      marker.shadow nil
      marker.json({
        id: current_visn[:id],
        number: current_visn[:number]
      })

      marker.infowindow render_to_string(partial: 'visns/maps/index_infowindow', locals: { visn: visn })
    end
  end

  def show
    @primary_visn_liaison = VisnLiaison.find_by(visn: @visn, primary: true)
    @visn_va_facilities = @visn.get_va_facilities

    @visn_va_facility_markers = Gmaps4rails.build_markers(@visn_va_facilities) do |facility, marker|

      va_facility = @visn_va_facilities.find { |vaf| vaf.id == facility.id }

      marker.lat va_facility[:latitude].to_s
      marker.lng va_facility[:longitude].to_s

      marker.picture({
                       url: view_context.image_path('visn-va-facility-map-marker-default.svg'),
                       width: 34,
                       height: 46,
                       scaledWidth: 34,
                       scaledHeight: 46
                     })

      marker.shadow nil
      marker.json({
        id: va_facility.id,
        type: va_facility.classification
      })

      marker.infowindow render_to_string(partial: 'visns/maps/show_infowindow', locals: { va_facility: va_facility })
    end

    searchable_practices = Practice.searchable_practices nil
    # set '@practices_json' to avoid js console error when utilizing the practices/search.js.erb file
    @practices_json = practices_json(searchable_practices)

    practices_created_by_visn = []
    helpers.get_created_practices_by_visn(searchable_practices, @visn, practices_created_by_visn)

    @practices_created_json = practices_json(practices_created_by_visn)
    # get the unique categories for practices created in a VISN
    @practices_created_categories = []
    get_categories_by_practices(practices_created_by_visn, @practices_created_categories)


    practices_adopted_by_visn = []
    helpers.get_adopted_practices_by_visn(searchable_practices, @visn, practices_adopted_by_visn)

    @practices_adopted_json = practices_json(practices_adopted_by_visn)
    # get the unique categories for practices adopted in a VISN
    @practices_adopted_categories = []
    get_categories_by_practices(practices_adopted_by_visn, @practices_adopted_categories)
  end

  private

  def set_visn
    # use find_by! in order to throw an exception if a visn with the number param does not exist
    @visn = Visn.find_by!(number: params[:number])
  end

  def get_categories_by_practices(practices, practice_categories)
    practices.each do |p|
      p.categories.where(is_other: false).where.not(name: 'Other').each do |c|
        practice_categories << c.name unless practice_categories.include?(c.name)
      end
    end
    practice_categories.sort_by! { |pc| pc.downcase }
  end
end