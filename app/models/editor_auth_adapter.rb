class EditorAuthAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    return true if user.has_role?(:admin)

    if subject.is_a?(Class)
      user.has_role?(:page_group_editor, :any) if subject <= Page || subject <= PageGroup
    else
      case subject
      when Page
        user.has_role?(:page_group_editor, subject.page_group)
      when PageGroup
        user.has_role?(:page_group_editor, subject)
      else
        false
      end
    end
  end
end
