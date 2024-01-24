class ActiveAdminAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    user.has_role?(:admin) || user.has_role?(:editor, :any) # TODO: move to relevant admin actions
  end
end
