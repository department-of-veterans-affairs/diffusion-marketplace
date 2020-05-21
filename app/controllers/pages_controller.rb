class PagesController < ApplicationController
  def show
    @breadcrumbs = [
        { text: 'Home', path: root_path },
        { text: 'COVID-19' }
    ]
  end
end