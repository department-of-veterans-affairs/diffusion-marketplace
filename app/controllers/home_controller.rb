class HomeController < ApplicationController

  def index
    @practices = Practice.searchable_practices 'a_to_z'
    @favorite_practices = current_user&.favorite_practices || []
    @facilities_data = facilities_json
    @highlighted_pr = Practice.where(highlight: true, published: true, enabled: true, approved: true).first
  end

  def diffusion_map
    @diffusion_history_practices = Practice.select(:id, :name).get_with_diffusion_histories
    @vamc_facilities = VaFacility.cached_va_facilities.select(:street_address_state, :official_station_name, :id, :common_name, :station_number, :latitude, :longitude, :slug, :fy17_parent_station_complexity_level, :visn_id, :rurality).order(:street_address_state, :official_station_name)
    @visns = Visn.cached_visns.select(:id, :number)
    @diffusion_histories = DiffusionHistory.get_with_practices.order(Arel.sql("lower(practices.name)"))

    @dh_markers = Gmaps4rails.build_markers(@diffusion_histories.group_by(&:facility_id)) do |dhg, marker|
      station_number = dhg[0]
      diffusion_histories = dhg[1]
      facility = @vamc_facilities.find {|f| f.station_number === station_number}
      marker.lat facility.latitude
      marker.lng facility.longitude

      marker.picture({
                         url: view_context.image_path('map-marker-default.svg'),
                         width: 31,
                         height: 44,
                         scaledWidth: 31,
                         scaledHeight: 44
                     })

      marker.shadow nil
      completed = 0
      in_progress = 0
      unsuccessful = 0
      diffusion_histories.each do |dh|
        dh_status = dh.diffusion_history_statuses.order(id: :desc).first
        completed += 1 if dh_status.get_status_display_name === DiffusionHistoryStatus::STATUSES[0]
        in_progress += 1 if dh_status.get_status_display_name === DiffusionHistoryStatus::STATUSES[1]
        unsuccessful += 1 if dh_status.get_status_display_name === DiffusionHistoryStatus::STATUSES[2]
      end
      practices = diffusion_histories.map(&:practice)
      marker.json({
                      id: facility.station_number,
                      practices: practices,
                      name: facility.official_station_name,
                      complexity: facility.fy17_parent_station_complexity_level,
                      visn: facility.visn.number,
                      rurality: facility.rurality,
                      completed: completed,
                      in_progress: in_progress,
                      unsuccessful: unsuccessful,
                      modal: render_to_string(partial: "maps/home_map_marker_modal",
                                              locals: {
                                                  diffusion_histories: diffusion_histories,
                                                  completed: completed,
                                                  in_progress: in_progress,
                                                  unsuccessful: unsuccessful,
                                                  facility: facility
                                              }
                      ),
                      facility: facility
                  })

      marker.infowindow render_to_string(partial: 'maps/infowindow', locals: {diffusion_histories: diffusion_histories, completed: completed, in_progress: in_progress, unsuccessful: unsuccessful, facility: facility, home_page: true})
    end
    render 'maps/diffusion_map'
  end

  def pii_phi_information
  end
end
