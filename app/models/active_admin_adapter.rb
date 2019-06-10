class ActiveAdminAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    user.has_role?(:admin)
  end
end
