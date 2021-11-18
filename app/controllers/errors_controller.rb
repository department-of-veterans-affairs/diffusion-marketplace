class ErrorsController < ApplicationController
  def page_not_found_404
    render 'errors/page_not_found_404', status: 404
  end
end