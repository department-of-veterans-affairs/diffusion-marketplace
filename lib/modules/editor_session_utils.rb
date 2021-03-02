module EditorSessionUtils
  def current_session(practice_id)
    PracticeEditorSession.find_by(practice_id: practice_id, session_end_time: nil)
  end
end