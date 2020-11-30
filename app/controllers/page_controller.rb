class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
    @path_parts = request.path.split('/')
    @facilities_data = facilities_json
    is_admin
  end

  def is_admin
    if current_user
      if not @page.published
        if not current_user.has_role?(:admin)
          redirect_to(root_path)
        end
      end
    else
      redirect_to(root_path)
    end
  end
end
