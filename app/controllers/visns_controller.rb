class VisnsController < ApplicationController
  before_action :set_visn, only: :show

  def index
    @visns = Visn.all

    visn_coordinates = [
      {"visn": 1, "latitude": "44.038318", "longitude": "-70.812705"},
      {"visn": 2, "latitude": "43.339237", "longitude": "-74.946322"},
      {"visn": 4, "latitude": "40.587924", "longitude": "-79.398574"},
      {"visn": 5, "latitude": "38.038397", "longitude": "-81.377433"},
      {"visn": 6, "latitude": "36.181158", "longitude": "-80.805763"},
      {"visn": 7, "latitude": "32.955324", "longitude": "-85.237351"},
      {"visn": 8, "latitude": "28.231763", "longitude": "-82.361857"},
      {"visn": 9, "latitude": "36.150834", "longitude": "-85.721825"},
      {"visn": 10, "latitude": "41.563706", "longitude": "-84.762654"},
      {"visn": 12, "latitude": "43.250833", "longitude": "-89.248069"},
      {"visn": 15, "latitude": "38.152211", "longitude": "-94.615368"},
      {"visn": 16, "latitude": "32.926156", "longitude": "-92.340574"},
      {"visn": 17, "latitude": "30.563018", "longitude": "-99.635602"},
      {"visn": 19, "latitude": "40.887056", "longitude": "-109.086884"},
      {"visn": 20, "latitude": "45.781449", "longitude": "-119.586845"},
      {"visn": 21, "latitude": "38.847748", "longitude": "-119.968209"},
      {"visn": 22, "latitude": "34.335098", "longitude": "-109.141066"},
      {"visn": 23, "latitude": "44.481282", "longitude": "-96.695541"}
    ]

    @visn_markers = Gmaps4rails.build_markers(@visns) do |visn, marker|

      current_visn = visn_coordinates.detect { |vc| vc[:visn] == visn.number }

      marker.lat current_visn[:latitude]
      marker.lng current_visn[:longitude]

      marker_url = view_context.image_path('map-marker-successful-default.svg')


      marker.picture({
                       url: marker_url,
                       width: 31,
                       height: 44,
                       scaledWidth: 31,
                       scaledHeight: 44
                     })

      marker.shadow nil
      # completed = 0
      # in_progress = 0
      # unsuccessful = 0
      # dhg[1].each do |dh|
      #   dh_status = dh.diffusion_history_statuses.order(created_at: :desc).first
      #   in_progress += 1 if dh_status.status == 'In progress' || dh_status.status == 'Planning' || dh_status.status == 'Implementing'
      #   completed += 1 if dh_status.status == 'Completed' || dh_status.status == 'Implemented' || dh_status.status == 'Complete'
      #   unsuccessful += 1 if dh_status.status == 'Unsuccessful'
      # end
      # practices = dhg[1].map(&:practice)
      marker.json({
                    number: current_visn[:number]
                  })

      # marker.infowindow render_to_string(partial: 'maps/infowindow', locals: {diffusion_histories: dhg[1], completed: completed, in_progress: in_progress, facility: facility})
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