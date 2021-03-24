class VisnsController < ApplicationController
  before_action :set_visn, only: :show

  def index
    @visns = Visn.cached_visns

    @visn_markers = Gmaps4rails.build_markers(@visns) do |visn, marker|

      current_visn = @visns.find { |vc| vc[:number] == visn.number }

      marker.lat current_visn[:latitude].to_s
      marker.lng current_visn[:longitude].to_s

      marker.picture({
                       url: view_context.image_path('visn-map-marker-default.svg'),
                       width: 48,
                       height: 64,
                       scaledWidth: 48,
                       scaledHeight: 64
                     })

      marker.shadow nil
      marker.json({ number: current_visn[:number] })

      marker.infowindow render_to_string(partial: 'visns/maps/infowindow', locals: { visn: visn })
    end
  end

  def show
  end

  private

  def set_visn
    # use find_by! in order to throw an exception if a visn with the number param does not exist
    @visn = Visn.find_by!(number: params[:number])
  end
end