class VisnsController < ApplicationController
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
    @visn_va_facilities = @visn.va_facilities

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
      marker.json({ id: va_facility.id })

      marker.infowindow render_to_string(partial: 'visns/maps/show_infowindow', locals: { va_facility: va_facility })
    end

    searchable_practices = Practice.searchable_practices

    practices_created_by_visn = []
    searchable_practices.each do |p|
      origin_facilities = p.practice_origin_facilities
      initiating_facility = p.initiating_facility
      # add practices that have practice_origin_facilities
      if p.facility? && origin_facilities.any?
        @visn_va_facilities.each do |vaf|
          origin_facilities.each do |of|
            practices_created_by_visn << p if of.facility_id === vaf.station_number.to_s
          end
        end
      # add practices that have an initiating_facility
      elsif p.visn? && initiating_facility.present?
        practices_created_by_visn << p if initiating_facility === @visn.id.to_s
      end
    end

    @practices_created_json = practices_json(practices_created_by_visn)

    practices_adopted_by_visn = []
    searchable_practices.each do |p|
      @visn_va_facilities.each do |vaf|
        p.diffusion_histories.each do |dh|
          practices_adopted_by_visn << p if dh.facility_id === vaf.station_number.to_s
        end
      end
    end

    @practices_adopted_json = practices_json(practices_adopted_by_visn)
  end

  private

  def set_visn
    # use find_by! in order to throw an exception if a visn with the number param does not exist
    @visn = Visn.find_by!(number: params[:number])
  end
end