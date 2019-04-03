class HomeController < ApplicationController

  def index
    @top_three_gold_practices = Practice.joins(:practice_partners).where(approved: true, published: true, practice_partners: {name: 'Diffusion of Excellence'}).limit(3).order(position: :asc)
  end

end
