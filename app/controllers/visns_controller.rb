class VisnsController < ApplicationController
  before_action :set_visn, only: :show
  before_action :set_visn_coordinates, only: :index

  def index
    @visns = Visn.cached_visns

    @visn_markers = Gmaps4rails.build_markers(@visns) do |visn, marker|

      current_visn = @visn_coordinates.find { |vc| vc[:number] == visn.number }

      marker.lat current_visn[:latitude]
      marker.lng current_visn[:longitude]

      marker.picture({
                       url: view_context.image_path('visn-map-marker-default.svg'),
                       width: 48,
                       height: 64,
                       scaledWidth: 48,
                       scaledHeight: 64
                     })

      marker.shadow nil
      marker.json({
                    number: current_visn[:number]
                  })

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

  def set_visn_coordinates
    @visn_coordinates = [
      {"number": 1, "latitude": "44.038318", "longitude": "-70.812705"},
      {"number": 2, "latitude": "43.339237", "longitude": "-74.946322"},
      {"number": 4, "latitude": "40.587924", "longitude": "-79.398574"},
      {"number": 5, "latitude": "38.038397", "longitude": "-81.377433"},
      {"number": 6, "latitude": "36.181158", "longitude": "-80.805763"},
      {"number": 7, "latitude": "32.955324", "longitude": "-85.237351"},
      {"number": 8, "latitude": "28.231763", "longitude": "-82.361857"},
      {"number": 9, "latitude": "36.150834", "longitude": "-85.721825"},
      {"number": 10, "latitude": "41.563706", "longitude": "-84.762654"},
      {"number": 12, "latitude": "43.250833", "longitude": "-89.248069"},
      {"number": 15, "latitude": "38.152211", "longitude": "-94.615368"},
      {"number": 16, "latitude": "32.926156", "longitude": "-92.340574"},
      {"number": 17, "latitude": "30.563018", "longitude": "-99.635602"},
      {"number": 19, "latitude": "40.887056", "longitude": "-109.086884"},
      {"number": 20, "latitude": "45.781449", "longitude": "-119.586845"},
      {"number": 21, "latitude": "38.847748", "longitude": "-119.968209"},
      {"number": 22, "latitude": "34.335098", "longitude": "-109.141066"},
      {"number": 23, "latitude": "44.481282", "longitude": "-96.695541"}
    ]
  end

end