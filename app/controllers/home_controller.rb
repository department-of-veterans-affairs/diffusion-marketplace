class HomeController < ApplicationController

  def index
    @practices = Practice.all
  end

end
