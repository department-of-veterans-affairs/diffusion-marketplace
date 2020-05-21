class NominatePracticesController < ApplicationController

  def index
    @breadcrumbs = [
      { text: 'Home', path: root_path },
      { text: 'Nominate a Practice' }
    ]
  end
end

