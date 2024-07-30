class HomeController < ApplicationController
  before_action :fetch_va_facilities, only: [:index, :diffusion_map]
  include CategoriesHelper


  def index
    @dropdown_categories = get_categories_by_popularity
    @dropdown_communities = get_categories_by_popularity(true)
    @dropdown_practices, @practice_names = get_dropdown_practices
  end

  def diffusion_map
    @map_data = fetch_map_data
    @include_google_maps = true
    render 'maps/diffusion_map'
  end

  private

  def fetch_map_data
    is_guest = helpers.is_user_a_guest?
    cache_key = is_guest ? "guest" : "non_guest"
    Rails.cache.fetch(["map_data", cache_key], expires_in: 24.hours) do
      diffusion_histories = DiffusionHistory.get_with_practices(is_guest)
      histories_for_markers = diffusion_histories.order(Arel.sql("lower(practices.name)"))
                                                 .exclude_clinical_resource_hubs
                                                 .group_by(&:va_facility_id)

      {
        visns: Visn.cached_visns.select(:id, :number),
        diffusion_history_practices: is_guest ? Practice.public_facing.select(:id, :name).get_with_va_facility_diffusion_histories :
                              Practice.select(:id, :name).get_with_va_facility_diffusion_histories,
        diffusion_histories: diffusion_histories,
        successful_ct: diffusion_histories.get_by_successful_status.size,
        in_progress_ct: diffusion_histories.get_by_in_progress_status.size,
        unsuccessful_ct: diffusion_histories.get_by_unsuccessful_status.size,
        dh_markers: build_markers(histories_for_markers)
      }
    end
  end

  def build_markers(diffusion_histories)
    Gmaps4rails.build_markers(diffusion_histories) do |dhg, marker|
      diffusion_histories = dhg[1]
      facility = @va_facilities.find(dhg[0])
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
  end

  def get_dropdown_practices
    practice_names = []
    practices_hash = dropdown_practices.pluck(:id, :name, :slug).map do |id, name, slug|
      practice_names << name
      {name: name, id: id, slug: slug }
    end

    return practices_hash, practice_names
  end

  def dropdown_practices
    scope = Practice.where(published: true, retired: false)
    scope = scope.where(is_public: true) if !current_user
    scope = scope.order("created_at DESC")
    scope
  end

  def get_diffusion_histories(is_public_practice)
    DiffusionHistory.get_with_practices(is_public_practice).order(Arel.sql("lower(practices.name)"))
  end

  def fetch_va_facilities
    latest_update = VaFacility.maximum(:updated_at).try(:to_i)
    cache_key = "va_facilities/relevant_attributes/#{latest_update}"

    @va_facilities = Rails.cache.fetch(cache_key) do
      VaFacility.where(hidden: false).get_relevant_attributes.order_by_state_and_station_name
    end
  end
end
