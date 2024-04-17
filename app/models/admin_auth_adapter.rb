class AdminAuthAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(_action, _subject)
    user.has_role?(:admin)
  end
end
