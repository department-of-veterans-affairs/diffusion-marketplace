class PageController < ApplicationController
  def show
    page_slug = params[:page_slug] ? params[:page_slug] : 'home'
    @page = Page.includes(:page_group).find_by(slug: page_slug, page_groups: {slug: params[:page_group_friendly_id]})
    @path_parts = request.path.split('/')
    @facilities_data = facilities_json

    if page_slug.include?('home')
      @breadcrumbs = [
          { text: 'Home', path: root_path },
          { text: "#{@page.title}" }
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
end
