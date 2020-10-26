class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
    @path_parts = request.path.split('/')
    @facilities_data = facilities_json
    is_admin
    # Start a new path
    session[:breadcrumbs] = []

    if page_slug == 'home'
      @breadcrumbs = [
          { text: 'Home', path: root_path },
          { text: "#{@page.page_group.name}" }
      ]
    elsif Page.where(slug: 'home', page_group_id: @page.page_group_id).exists?
       @breadcrumbs = [
           { text: 'Home', path: root_path },
           { text: "#{@page.page_group.name}" , path: "/#{@page.page_group.slug}"},
           { text: "#{@page.title}" }
       ]
    else
      @breadcrumbs = [
          { text: 'Home', path: root_path },
          { text: "#{@page.page_group.name}" , path: ''},
          { text: "#{@page.title}" }
      ]
    end
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
