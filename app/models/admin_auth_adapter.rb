class AdminAuthAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    return true if user.has_role?(:admin)
    false
  end
end
