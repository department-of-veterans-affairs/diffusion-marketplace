module PracticeEditorUtils
  def is_user_an_editor_for_practice(practice, user)
    PracticeEditor.where(innovable: practice, user: user).present?
  end
end