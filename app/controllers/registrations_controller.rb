# Override the devise registrations controller
class RegistrationsController < Devise::RegistrationsController
  
  def edit
    super
  end
end
