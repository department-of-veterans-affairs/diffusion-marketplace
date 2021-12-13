class ErrorsController < ApplicationController
  def page_not_found_404
    render 'errors/page_not_found_404', status: 404
  end

  def internal_server_error_500
    render 'errors/internal_server_error_500', status: 500
  end
end