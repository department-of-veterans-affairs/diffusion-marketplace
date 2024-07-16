class SessionsController < Devise::SessionsController
  def new
    unless Rails.env.production?
      super
    else
      redirect_to root_path
    end
  end
end
