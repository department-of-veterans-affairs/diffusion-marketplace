class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
    @page_components = @page.page_components
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
    set_pagy_event_list_items_array(events)
    set_pagy_news_items_array(news_items)
  end

  def set_pagy_event_list_items_array(page_components)
    page_event_list_index = 0 # TODO: support multiple event lists per page
    params_index = params["#{page_event_list_index}"]
    events = []
    page_components.each do |pc|
      component = pc.component
      events << component
      @event_ids << pc.component_id
    end

    if events.present?
      pagy_events, paginated_events = get_pagy_events_array(events,page_event_list_index, params_index)
      @event_list_components[0] = {
        pagy: pagy_events,
        events: paginated_events
      }
    end
  end

  def get_pagy_events_array (events, page_event_list_index, params_index)
    pagy_array(
          events,
          items: 3,
          page_param: "events-#{page_event_list_index.to_s}",
          link_extra: "data-remote='true' class='dm-paginated-events-#{page_event_list_index}-link dm-paginated-#{page_event_list_index}-events-#{params_index.nil? ? 2 : params_index.to_i + 1}-link dm-button--outline-secondary margin-top-105 width-auto'"
        )
  end

  def set_pagy_news_items_array(page_components)
    page_news_item_list_index = 0 # TODO: support multiple news item lists per page
    params_index = params["#{page_news_item_list_index}"]
    news_items = []
    page_components.each do |pc|
      component = pc.component
      news_items << component
      @news_items_ids << pc.component_id
    end

    if news_items.present?
      pagy_news_items, paginated_news_items = get_pagy_news_items_array(news_items,page_news_item_list_index, params_index)
      @news_items_components[0] = {
        pagy: pagy_news_items,
        news_items: paginated_news_items
      }
    end
  end

  def get_pagy_news_items_array (news_items, page_news_item_list_index, params_index)
    pagy_array(
          news_items,
          items: 6,
          page_param: "news-#{page_news_item_list_index.to_s}",
          link_extra: "data-remote='true' class='dm-paginated-news-items-#{page_news_item_list_index}-link dm-paginated-#{page_news_item_list_index}-news-items-#{params_index.nil? ? 2 : params_index.to_i + 1}-link dm-button--outline-secondary margin-top-105 width-auto'"
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
        @practice_list_components[page_practice_list_index][:pagy], @practice_list_components[page_practice_list_index][:paginated] = get_pagy_practices_array(practices, page_practice_list_index, params_index)
      else
        pagy_practices, paginated_practices = get_pagy_practices_array(practices, page_practice_list_index, params_index)
        practice_list_pagy = { pagy: pagy_practices, practices: paginated_practices}
        @practice_list_components.push(practice_list_pagy)
      end
      page_practice_list_index += 1
    end
  end

  def get_pagy_practices_array (practices, page_practice_list_index, params_index)
    pagy_array(
          practices,
          items: 6,
          page_param: "practices-#{page_practice_list_index.to_s}",
          link_extra: "data-remote='true' class='dm-paginated-practices-#{page_practice_list_index}-link dm-paginated-#{page_practice_list_index}-practices-#{params_index.nil? ? 2 : params_index.to_i + 1}-link dm-button--outline-secondary margin-top-105 width-auto'"
        )
  end
end
