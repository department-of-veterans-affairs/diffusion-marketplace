class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
    @path_parts = request.path.split('/')
    @facilities_data = VaFacility.cached_va_facilities
    unless @page.published
      redirect_to(root_path) unless current_user.has_role?(:admin)
    end
  end
end
