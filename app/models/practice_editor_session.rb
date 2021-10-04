class PracticeEditorSession < ApplicationRecord
  include EditorSessionUtils
  belongs_to :practice
  belongs_to :user

  def self.session_out_of_time(session)
    is_published = session.practice.published
    is_published ? session_end = DateTime.now.utc - 20.minutes : session_end = DateTime.now.utc - 30.minutes
    if session.session_start_time < session_end
      session.session_end_time = DateTime.now
      session.save
      return true
    end
    return false
  end

  def self.lock_practice_for_user(user_id, practice_id)
    PracticeEditorSession.create user_id: user_id, practice_id: practice_id, session_start_time: DateTime.now, session_end_time: nil
  end

  def self.extend_current_session(session)
    session.session_start_time = DateTime.now
    session.save
  end

  def self.close_current_session(session)
    session.session_end_time = DateTime.now
    session.save
  end

  def self.get_minutes_remaining_in_session(session, is_published)
    #TODO: change this back to 20......... set to 2...? only for testing..... bj_2_10_2021
    if is_published
      ret_val =  20 - minutes_in_session(session.session_start_time).to_i
    else
      ret_val =  30 - minutes_in_session(session.session_start_time).to_i
    end
    ret_val
  end

  def self.minutes_in_session(session_start_time)
    minutes = ((DateTime.now - session_start_time.to_datetime) * 24 * 60).to_i
    return minutes
  end
end
