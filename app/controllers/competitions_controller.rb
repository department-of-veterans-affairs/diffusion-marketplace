class CompetitionsController < ApplicationController
  def shark_tank
    @breadcrumbs = [
        { text: 'Home', path: root_path },
        { text: 'Shark Tank Competition' }
    ]
    @facilities_data = facilities_json
  end
end