class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
    @page_components = @page.page_components
    @page_components.each do |pc|
      if pc.component_type == "PageMapComponent"
        @practices_list = PageMapComponent.find_by_id(pc.component_id)
        @short_name = @practices_list.short_name
        adoptions = helpers.get_adopting_facilities_for_these_practices(@practices_list, @practices_list.display_successful_adoptions, @practices_list.display_in_progress_adoptions, @practices_list.display_unsuccessful_adoptions)
        build_map_component adoptions
        @adoptions_count = adoptions.count
      end
    end

    @path_parts = request.path.split('/')
    @facilities_data = VaFacility.cached_va_facilities.order_by_station_name
    @practice_list_components = []
    set_pagy_practice_list_array(@page_components)
    @pagy_type = params.keys.first.to_i || nil
    @practice_list_component_index = 0
    unless @page.published
      redirect_to(root_path) if current_user.nil? || !current_user.has_role?(:admin)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end


  private

  def build_map_component(adopting_facilities_list)
    va_facilities = VaFacility.where(id: adopting_facilities_list)
    @va_facility_marker = Gmaps4rails.build_markers(va_facilities) do |facility, marker|
      marker.lat facility.latitude
      marker.lng facility.longitude
      marker.picture({
                         url: view_context.image_path('map-marker-default.svg'),
                         width: 34,
                         height: 46,
                         scaledWidth: 34,
                         scaledHeight: 46
                     })
      marker.shadow nil
      marker.json({ id: facility.id })
      marker.infowindow render_to_string(partial: 'maps/page_map_infowindow', locals: { diffusion_histories: facility, facility: facility, practice_list: @practices_list })
    end
  end


  def set_pagy_practice_list_array(page_components)
    page_practice_list_index = 0
    params_index = params["#{page_practice_list_index}"]

    page_components.each_with_index do |pc, index|
      if pc.component_type === 'PagePracticeListComponent'
        component = pc.component_type.constantize.find(pc.component_id)
        practices_ids = component.practices
        practices = helpers.is_user_a_guest? ? Practice.where(id: practices_ids).public_facing.sort_by_retired.sort_a_to_z : Practice.where(id: practices_ids).published_enabled_approved.sort_by_retired.sort_a_to_z

        if @practice_list_components[page_practice_list_index].present?
          @practice_list_components[page_practice_list_index][:pagy], @practice_list_components[page_practice_list_index][:paginated] = get_pagy_practices_array(practices, page_practice_list_index, params_index)
        else
        pagy_practices, paginated_practices = get_pagy_practices_array(practices, page_practice_list_index, params_index)
        practice_list_pagy = { pagy: pagy_practices, practices: paginated_practices}
        @practice_list_components.push(practice_list_pagy)
        end
        page_practice_list_index += 1
      end
    end
  end

  def get_pagy_practices_array (practices, page_practice_list_index, params_index)
    return pagy_array(
          practices,
          items: 6,
          page_param: page_practice_list_index.to_s,
          link_extra: "data-remote='true' class='dm-paginated-#{page_practice_list_index}-link dm-paginated-#{page_practice_list_index}-practices-#{params_index.nil? ? 2 : params_index.to_i + 1}-link dm-button--outline-secondary margin-top-105 width-auto'"
        )
  end

  # def get_adopting_facilities_for_these_practices(practices_list, successful_adoptions, in_progress_adoptions, unsuccessful_adoptions)
  #   va_facilities_list = []
  #   practices_list.practices.each do |pr|
  #     diffusion_histories = DiffusionHistory.where(practice_id: pr)
  #     diffusion_histories.each do |dh|
  #       dhs = DiffusionHistoryStatus.where(diffusion_history_id: dh[:id]).first.status
  #       unless dh.va_facility_id.nil?
  #         if (dhs == 'Completed' || dhs == 'Implemented' || dhs == 'Complete') && successful_adoptions
  #           va_facilities_list.push dh.va_facility_id
  #         elsif (dhs == 'In progress' || dhs == 'Planning' || dhs == 'Implementing') && in_progress_adoptions
  #           va_facilities_list.push dh.va_facility_id
  #         elsif dhs == "Unsuccessful" && unsuccessful_adoptions
  #           va_facilities_list.push dh.va_facility_id
  #         end
  #       end
  #     end
  #   end
  #   va_facilities_list
  # end
end
