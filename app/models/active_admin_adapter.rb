# frozen_string_literal: true

class ActiveAdminAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(_action, _subject = nil)
    user.has_role?(:admin)
  end
end
