class PageController < ApplicationController
  def show
    @page = Page.includes(:page_group).where(slug: params[:page_slug], page_groups: {slug: params[:page_group_friendly_id]}).first
  end
end
