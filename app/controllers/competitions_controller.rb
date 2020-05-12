class CompetitionsController < ApplicationController
  before_action :set_facility_data, only: [:shark_tank, :go_fish]

  def shark_tank
    @breadcrumbs = [
        { text: 'Home', path: root_path },
        { text: 'Shark Tank' }
    ]
  end

  def go_fish
    redirect_to root_path
  end

  private

  def set_facility_data
    @facilities_data = facilities_json
  end
end