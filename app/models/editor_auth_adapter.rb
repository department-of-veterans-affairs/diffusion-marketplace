class EditorAuthAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    return true if user.has_role?(:admin)

    case subject
    when normalized(Page)
      user.has_role?(:page_group_editor, :any)
    else
      false
    end
  end
end
