class HomeController < ApplicationController

  def index
    @top_practice = Practice.find_by_highlight true
    @featured_practices = Practice.where featured: true
    @favorite_practices = current_user&.favorite_practices || []

    @facilities_data = facilities_json['features']

    vamc_facilities = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    @diffusion_histories = Gmaps4rails.build_markers(DiffusionHistory.all.group_by(&:facility_id)) do |dhg, marker|

      facility = vamc_facilities.find {|f| f['StationNumber'] == dhg[0]}
      marker.lat facility['Latitude']
      marker.lng facility['Longitude']

      marker.picture({
                         url: view_context.image_path('map-marker-default.svg'),
                         width: 31,
                         height: 44
                     })
      # marker.picture({
      #                    rich_marker: "<div class='my-marker'>It works!<img height='30' width='30' src='http://farm4.static.flickr.com/3212/3012579547_097e27ced9_m.jpg'/></div>"
      #                })

      marker.shadow nil
      completed = 0
      in_progress = 0

      dhg[1].each do |dh|
        dh_status = dh.diffusion_history_statuses.where(end_time: nil).first
        completed += 1 if dh_status.status == 'Completed' || 'Implemented'
        in_progress += 1 if dh_status.status == 'In progress' || 'Planning'
      end

      marker.json({
                      id: facility["StationNumber"],
                      practices: dhg[1],
                      name: facility["OfficialStationName"],
                      complexity: facility["FY17ParentStationComplexityLevel"],
                      visn: facility["VISN"],
                      rurality: facility["Rurality"],
                      completed: completed,
                      in_progress: in_progress,
                      # custom_marker: render_to_string(partial: 'maps/marker', locals: {diffusion_histories: dhg[1], completed: completed, in_progress: in_progress, facility: facility})
                  })

      marker.infowindow render_to_string(partial: 'maps/infowindow', locals: {diffusion_histories: dhg[1], completed: completed, in_progress: in_progress, facility: facility})
    end
  end


end
