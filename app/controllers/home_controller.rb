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

      marker.json({
                      id: facility["StationNumber"],
                      practices: dhg[1],
                      name: facility["OfficialStationName"],
                      complexity: facility["FY17ParentStationComplexityLevel"],
                      visn: facility["VISN"],
                      rurality: facility["Rurality"]
                  })
      marker.label('1')


      marker.infowindow render_to_string(partial: 'maps/marker', locals: {diffusion_histories: dhg[1], facility: facility})
    end
  end

end
