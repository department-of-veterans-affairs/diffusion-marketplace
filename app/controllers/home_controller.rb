class HomeController < ApplicationController
  before_action :fetch_va_facilities, only: [:index, :diffusion_map]
  include CategoryUsageUtils


  def index
    @practices = Practice.searchable_practices 'a_to_z'
    @favorite_practices = current_user&.favorite_practices || []
    @highlighted_pr = Practice.where(highlight: true, published: true, enabled: true, approved: true).first
    #@popular_categories = get_top_six_categories
  end

  def diffusion_map
    @diffusion_history_practices = Practice.select(:id, :name).get_with_diffusion_histories
    @visns = Visn.cached_visns.select(:id, :number)
    @diffusion_histories = DiffusionHistory.get_with_practices.order(Arel.sql("lower(practices.name)"))
    @successful_ct = @diffusion_histories.get_by_successful_status.size
    @in_progress_ct = @diffusion_histories.get_by_in_progress_status.size
    @unsuccessful_ct = @diffusion_histories.get_by_unsuccessful_status.size

    @dh_markers = Gmaps4rails.build_markers(@diffusion_histories.group_by(&:va_facility_id)) do |dhg, marker|
      station_number = @va_facilities.find(dhg[0]).station_number
      diffusion_histories = dhg[1]
      facility = @va_facilities.find { |f| f.station_number === station_number }
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

  private

  def fetch_va_facilities
    @va_facilities = VaFacility.cached_va_facilities.get_relevant_attributes
  end
end
