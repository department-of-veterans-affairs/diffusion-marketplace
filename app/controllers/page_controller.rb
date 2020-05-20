class PageController < ApplicationController
  def show
    @page = Page.includes(:page_group).find_by(slug: params[:page_slug], page_groups: {slug: params[:page_group_friendly_id]})
    @facilities_data = facilities_json
  end
end
