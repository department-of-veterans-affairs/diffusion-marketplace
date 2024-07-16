# Override the devise registrations controller
class RegistrationsController < Devise::RegistrationsController

  def edit
    super
  end

  def new
    redirect_to root_path
  end
end
