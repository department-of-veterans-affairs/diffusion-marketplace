class HomeController < ApplicationController

  def index
    @top_three_gold_practices = Practice.where(approved: true, published: true).limit(3).order(position: :asc)
  end

end
