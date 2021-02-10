module PracticeEditorUtils
  def is_user_an_editor_for_practice(practice, user)
    PracticeEditor.where(practice: practice, user: user).present?
  end
end