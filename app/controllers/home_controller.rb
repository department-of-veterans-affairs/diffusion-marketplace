class HomeController < ApplicationController

  def index
    @top_practice = Practice.find_by_highlight true
    @featured_practices = Practice.where featured: true

    @facilities_data = facilities_json['features']
  end

end
