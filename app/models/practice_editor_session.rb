class PracticeEditorSession < ApplicationRecord
  belongs_to :practice

  # returns 0 if not locked and returns the practice_editor_session id if locked
  def self.practice_locked(cur_user_id, practice_id)
    rec = PracticeEditorSession.where(practice_id: practice_id, session_end_time: nil).where.not(session_start_time: nil).order("session_start_time DESC")
    return 0 if rec.count == 0
    return rec[0].id
  end
  def self.lock_practice_for_user(user_id, practice_id)
    PracticeEditorSession.create user_id: user_id, practice_id: practice_id, session_start_time: DateTime.now, session_end_time: nil
  end
  def self.locked_by(rec_id, include_time = true)
    rec = PracticeEditorSession.find_by_id(rec_id)
    user_id = rec.user_id
    user = User.find_by_id(user_id)
    first_name = user.first_name.nil? ? "?" : user.first_name
    last_name = user.last_name.nil? ? "?" : user.last_name
    if include_time
      return first_name + " " + last_name + " @" + rec.session_start_time.to_s
    end
    return first_name + " " + last_name
  end
  def self.locked_by_user_id(rec_id)
    rec = PracticeEditorSession.find_by_id(rec_id)
    user_id = rec.user_id
    user = User.find_by_id(user_id)
    return user.blank? ? 0 : user.id
  end
  def self.is_admin(user_id)
    sql = "select r.name from roles r join users_roles ur on r.id = ur.role_id join users u on ur.user_id = u.id where u.id = $1"
    param1 = "#{user_id}"
    records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1]])
    if records_array.count == 1 then
      if records_array[0]["name"] == "admin" then
        return true
      end
    end
    return false
  end
  def self.practice_last_updated(practice_id)
    session = PracticeEditorSession.where(practice_id: practice_id).where.not(session_end_time: nil).order("session_end_time DESC").first()
    return "" if session.blank?
    lock_user = locked_by(session.id, false)
    s_text = "Practice last updated on " + session.session_end_time.strftime("%B %d, %Y") + " at " + session.session_end_time.strftime("%I:%M %p").gsub(/^0/,'')
    s_text += " by " +  lock_user
    if is_admin(session.user_id)
      s_text += " (Site Admin)"
    end
    s_text
  end
end