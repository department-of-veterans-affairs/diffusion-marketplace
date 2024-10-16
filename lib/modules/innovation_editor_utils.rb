module InnovationEditorUtils
  def is_user_an_editor_for_innovation(innovation, user)
    PracticeEditor.where(innovable: innovation, user: user).present?
  end
end