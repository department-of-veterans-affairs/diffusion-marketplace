class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
    @page_components = @page.page_components
    get_map_components(@page_components)
    @path_parts = request.path.split('/')
    @facilities_data = VaFacility.cached_va_facilities.order_by_station_name
    @practice_list_components = []
    @pagy_type = params.keys.first || nil
    @practice_list_component_index = 0
    @event_ids = []
    @event_list_components = {}
    @news_items_components = {}
    @news_items_ids = []
    collect_paginated_components(@page_components)
    unless @page.published
      redirect_to(root_path) if current_user.nil? || !current_user.has_role?(:admin)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end


  private

  def get_map_components(page_components)
    page_components.each do |pc|
      if pc.component_type == "PageMapComponent"
        @map_component = PageMapComponent.find_by_id(pc.component_id)
        build_map_component(@map_component.get_adopting_facility_ids)
      end
    end
  end

  def build_map_component(adopting_facility_ids)
    va_facilities = VaFacility.where(id: adopting_facility_ids)
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
      practice_data =  @map_component.get_practice_data_by_diffusion_histories(facility.id)
      marker.infowindow render_to_string(
                            partial: 'maps/page_map_infowindow',
                            locals: {
                                facility: facility,
                                map_component: @map_component,
                                practice_data: practice_data
                            }
                        )
    end
  end

  def collect_paginated_components(page_components)
    practice_lists = []
    events = []
    news_items = []
    page_components.each do |pc|
      practice_lists << pc if pc.component_type === 'PagePracticeListComponent'
      events << pc if pc.component_type === 'PageEventComponent'
      news_items << pc if pc.component_type === 'PageNewsComponent'
    end

    set_pagy_practice_list_array(practice_lists)
    paginate_components(events, "events", 3)
    paginate_components(news_items, "news", 6)
  end

  def paginate_components(page_components, component_type, pagination)
    return unless page_components
    page_item_list_index = 0
    params_index = params["#{page_item_list_index}"]
    items = []
    ids = []

    page_components.each do |pc|
      items << pc.component
      ids << pc.component_id
    end

    pagy_settings, paginated_items = get_pagy_array(items, page_item_list_index, params_index, pagination, component_type)

    if component_type == "events"
      @event_list_components[0] = { pagy: pagy_settings, events: paginated_items }
      @event_ids = ids
    elsif component_type == "news"
      @news_items_components[0] = { pagy: pagy_settings, news: paginated_items }
      @news_items_ids = ids
    end
  end

  def get_pagy_array(items, page_item_list_index, params_index, pagination, item_class)
    pagy_array(
      items,
      items: pagination,
      page_param: "#{item_class}-#{page_item_list_index.to_s}",
      link_extra: "data-remote='true' class='dm-paginated-#{item_class}-#{page_item_list_index}-link dm-paginated-#{page_item_list_index}-#{item_class}-#{params_index.nil? ? 2 : params_index.to_i + 1}-link dm-button--outline-secondary margin-top-105 width-auto'"
    )
  end

  def set_pagy_practice_list_array(page_components)
    page_practice_list_index = 0
    params_index = params["#{page_practice_list_index}"]

    page_components.each do |pc|
      component = pc.component
      practices_ids = component.practices
      practices = helpers.is_user_a_guest? ? Practice.where(id: practices_ids).public_facing.sort_by_retired.sort_a_to_z : Practice.where(id: practices_ids).published_enabled_approved.sort_by_retired.sort_a_to_z

      if @practice_list_components[page_practice_list_index].present?
        @practice_list_components[page_practice_list_index][:pagy], @practice_list_components[page_practice_list_index][:paginated] = get_pagy_array(practices, page_practice_list_index, params_index, 6, "practices")
      else
        pagy_practices, paginated_practices = get_pagy_array(practices, page_practice_list_index, params_index, 6, "practices")
        practice_list_pagy = { pagy: pagy_practices, practices: paginated_practices}
        @practice_list_components.push(practice_list_pagy)
      end
      page_practice_list_index += 1
    end
  end
end
