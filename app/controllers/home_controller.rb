class HomeController < ApplicationController

  def index
    # TODO: make this configurable
    @top_practice = Practice.find_by(name: 'Project HAPPEN')


    # display the "Terrible Trio" && make configurable
    # TODO: import Rapid Naloxone
    naloxone = Practice.find_by(name: 'Rapid Naloxone')
    my_life_my_story = Practice.find_by(name: 'My Life, My Story')
    stride = Practice.find_by(name: 'Getting Hospitalized Veterans Back on Their Feet: The STRIDE Program')

    @featured_practices = [naloxone, my_life_my_story, stride]

    @facilities_data = facilities_json['features']
  end

end
