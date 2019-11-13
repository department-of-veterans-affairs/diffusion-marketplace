class HomeController < ApplicationController

  def index
    @top_practice = Practice.find_by_highlight true
    @featured_practices = Practice.where featured: true
    @practices = Practice.where(approved: true, published: true).order(name: :asc)
    @favorite_practices = current_user&.favorite_practices || []

    @facilities_data = facilities_json

    @vamc_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))

    @diffused_practices = DiffusionHistory.all

    @diffusion_histories = Gmaps4rails.build_markers(@diffused_practices.group_by(&:facility_id)) do |dhg, marker|

      facility = @vamc_facilities.find {|f| f['StationNumber'] == dhg[0]}
      marker.lat facility['Latitude']
      marker.lng facility['Longitude']

      marker.picture({
                         url: view_context.image_path('map-marker-default.svg'),
                         width: 31,
                         height: 44
                     })

      marker.shadow nil
      completed = 0
      in_progress = 0
      unsuccessful = 0
      dhg[1].each do |dh|
        dh_status = dh.diffusion_history_statuses.where(end_time: nil).first
        in_progress += 1 if dh_status.status == 'In progress' || dh_status.status ==  'Planning' || dh_status.status == 'Implementing'
        completed += 1 if dh_status.status == 'Completed' || dh_status.status ==  'Implemented' || dh_status.status == 'Complete'
        unsuccessful += 1 if dh_status.status == 'Unsuccessful'
      end
      practices = dhg[1].map(&:practice)
      marker.json({
                      id: facility["StationNumber"],
                      practices: practices,
                      name: facility["OfficialStationName"],
                      complexity: facility["FY17ParentStationComplexityLevel"],
                      visn: facility["VISN"],
                      rurality: facility["Rurality"],
                      completed: completed,
                      in_progress: in_progress,
                      unsuccessful: unsuccessful,
                      modal: render_to_string(partial: "maps/home_map_marker_modal",
                                              locals: {
                                                  diffusion_histories: dhg[1],
                                                  completed: completed,
                                                  in_progress: in_progress,
                                                  facility: facility
                                              }
                      ),
                      facility: facility
                  })

      marker.infowindow render_to_string(partial: 'maps/infowindow', locals: {diffusion_histories: dhg[1], completed: completed, in_progress: in_progress, facility: facility, home_page: true})
    end
  end

  def search
    ahoy.track "Practice search", {search_term: request.params[:query]} if request.params[:query].present?
    @practices = Practice.where(approved: true, published: true).order(name: :asc)
    @facilities_data = facilities_json['features']
    @practices_json = practices_json(@practices)
  end


end
