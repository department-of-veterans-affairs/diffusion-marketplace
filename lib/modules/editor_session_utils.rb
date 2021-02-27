module EditorSessionUtils
  def current_session(practice_id, user_id)
    PracticeEditorSession.find_by(practice_id: practice_id, user_id: user_id, session_end_time: nil)
  end
end