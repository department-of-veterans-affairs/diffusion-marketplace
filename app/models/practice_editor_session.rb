class PracticeEditorSession < ApplicationRecord
  belongs_to :practice

  # returns 0 if not locked and returns the practice_editor_session id if locked
  def self.practice_locked(cur_user_id, practice_id)
    rec = PracticeEditorSession.where(:practice_id == practice_id && :session_start_time != nil && :session_end_time == nil).order("session_start_time DESC")
    debugger
    return 0 if rec.count == 0
    return rec[0].id
  end
  def self.lock_practice_for_user(user_id, practice_id)
    PracticeEditorSession.create user_id: user_id, practice_id: practice_id, session_start_time: DateTime.now, session_end_time: nil
  end
  def self.locked_by(rec_id)
    rec = PracticeEditorSession.find_by_id(rec_id)
    user_id = rec.user_id
    user = User.find_by_id(user_id)
    return user.first_name + " " + user.last_name + " @" + rec.session_start_time.to_s
  end
  def self.locked_by_user_id(rec_id)
    rec = PracticeEditorSession.find_by_id(rec_id)
    user_id = rec.user_id
    user = User.find_by_id(user_id)
    return user.blank? ? 0 : user.id
  end
end