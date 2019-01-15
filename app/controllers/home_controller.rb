class HomeController < ApplicationController

  def index
    @top_three_gold_practices = Practice.limit(3)
  end

end
