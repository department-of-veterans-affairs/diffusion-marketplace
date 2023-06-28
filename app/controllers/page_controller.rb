class PageController < ApplicationController
  before_action :set_page, only: :show
  before_action :set_page_components, only: :show

  def show
    page_group = @page.page_group
    @map_components_with_markers = build_map_component_markers
    @path_parts = request.path.split('/')
    @facilities_data = VaFacility.cached_va_facilities.order_by_station_name
    @practice_list_components = []
    @pagy_type = params.keys.first || nil
    @practice_list_component_index = 0
    @event_list_component_index = 0
    @event_list_components = []
    @event_ids = []
    @news_list_component_index = 0
    @news_items_components = []
    @news_items_ids = []
    collect_paginated_components(@page_components)

    if page_group.is_community? && !request.url.include?('/communities')
      is_landing_page = @page_slug == 'home'
      host_name = ENV["HOSTNAME"]
      communities_url = "#{host_name}/communities/#{page_group.slug}#{'/' + @page_slug unless is_landing_page}"

      redirect_to(URI.parse(communities_url).path)
    elsif !@page.published
      redirect_to(root_path) if current_user.nil? || !current_user.has_role?(:admin)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_page
    @page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: @page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
  end

  def set_page_components
    @page_components = @page.page_components
  end

  def build_map_component_markers
    map_components_with_markers = {}
    @page_components.each do |pc|
      # If the page component is a map, add the ActiveRecord and the map markers to the hash, using the id as the key
      if pc.component_type == "PageMapComponent"
        map_component = PageMapComponent.find_by_id(pc.component_id)
        va_facilities = VaFacility.where(id: map_component.get_adopting_facility_ids)

        map_components_with_markers[pc.id.to_s.to_sym] = {
          component: map_component,
          markers: Gmaps4rails.build_markers(va_facilities) do |facility, marker|
            marker.lat facility.latitude
            marker.lng facility.longitude
            marker.picture(
              {
                 url: view_context.image_path('map-marker-default.svg'),
                 width: 34,
                 height: 46,
                 scaledWidth: 34,
                 scaledHeight: 46
              }
            )
            marker.shadow nil
            practice_data =  map_component.get_practice_data_by_diffusion_histories(facility.id)
            marker.json(
              {
                facility: facility,
                total_adoption_count: practice_data.length
              }
            )
            marker.infowindow render_to_string(
                                partial: 'maps/page_map_infowindow',
                                locals: {
                                  facility: facility,
                                  map_component: map_component,
                                  practice_data: practice_data
                                }
                              )
          end
        }
      end
    end

    map_components_with_markers
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

    set_pagy_practice_list_array(practice_lists) if practice_lists.present?
    paginate_components(events, "events", 2) if events.present?
    paginate_components(news_items, "news", 4) if news_items.present?
  end

  # Paginate adjacent news or event components
  def paginate_components(page_components, component_type, pagination)
    return unless page_components

    page_item_list_index = 0
    params_index = params[page_item_list_index.to_s]
    items = []
    ids = []
    position = page_components.first&.position
    ids << page_components.first&.component_id

    # create list for adjacent components of the same type
    page_components.each do |pc|
      if pc.position == position || pc.position == position + 1
        (items[page_item_list_index] ||= []) << pc.component
      else
        # create pagy for previous list
        add_paginated_list(component_type, page_item_list_index, params_index, items, pagination)
        # begin a new list
        page_item_list_index += 1
        items[page_item_list_index] = [pc.component]
        ids << pc.component_id
      end
      position = pc.position
    end
    # create pagy for the final list
    add_paginated_list(component_type, page_item_list_index, params_index, items, pagination)
    set_pagination_start_ids(component_type, ids)
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

  # create a paginated list and add it to page components
  def add_paginated_list(component_type, page_item_list_index, params_index, items, pagination)
    pagy_settings, paginated_items = get_pagy_array(items[page_item_list_index], page_item_list_index, params_index, pagination, component_type)
    case component_type
    when "events"
      @event_list_components << { pagy: pagy_settings, events: paginated_items }
    when "news"
      @news_items_components << { pagy: pagy_settings, news: paginated_items }
    end
  end

  def get_pagy_array(items, page_item_list_index, params_index, pagination, item_class)
    pagy_array(
      items,
      items: pagination,
      page_param: "#{item_class}-#{page_item_list_index}",
      link_extra: "data-remote='true' class='dm-paginated-#{item_class}-#{page_item_list_index}-link dm-paginated-#{page_item_list_index}-#{item_class}-#{params_index.nil? ? 2 : params_index.to_i + 1}-link dm-button--outline-secondary margin-top-105 width-auto'"
    )
  end

  def set_pagination_start_ids(component_type, ids)
    case component_type
    when "events"
      @event_ids = ids
    when "news"
      @news_items_ids = ids
    end
  end
end
