class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
    @page_components = @page.page_components
    @path_parts = request.path.split('/')
    @facilities_data = VaFacility.cached_va_facilities
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
end
