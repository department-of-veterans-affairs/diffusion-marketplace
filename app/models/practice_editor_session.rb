class PracticeEditorSession < ApplicationRecord
  include EditorSessionUtils
  belongs_to :practice
  belongs_to :user

   def self.practice_locked_for_current_user(cur_user_id, practice_id)
    rec = PracticeEditorSession.where(practice_id: practice_id, session_end_time: nil).where.not(session_start_time: nil).order("session_start_time DESC").first()
    return false if rec.blank?
    if rec.user_id == cur_user_id
      return false
    end
    return true
  end
  # returns 0 if not locked and returns the practice_editor_session id if locked
  def self.practice_locked(practice_id)
    rec = PracticeEditorSession.where(practice_id: practice_id, session_end_time: nil).where.not(session_start_time: nil).last
    return 0 if rec.nil?
    return rec.id
  end

  def self.session_out_of_time(session)
    is_published = session.practice.published
    is_published ? session_end = DateTime.now.utc - 15.minutes : session_end = DateTime.now.utc - 30.minutes
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

  def self.practice_last_updated(practice_id)
    session = PracticeEditorSession.where(practice_id: practice_id).where.not(session_end_time: nil).order("session_end_time DESC").first
    return "" if session.blank?
    lock_user = session.user.full_name === 'User' ? session.user.email : session.user.full_name
    s_text = "Practice last updated on #{session.session_end_time.strftime("%B %d, %Y")} at #{session.session_end_time.strftime("%I:%M %p")}".gsub(/^0/,'')
    s_text += " by #{lock_user}"
    if session.user.roles.find_by(name: 'admin').present?
      s_text += " (Site Admin)"
    end
    s_text
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
    #TODO: change this back to 15......... set to 2...? only for testing..... bj_2_10_2021
    if is_published
      ret_val =  15 - minutes_in_session(session.session_start_time).to_i
    else
      ret_val =  30 - minutes_in_session(session.session_start_time).to_i
    end
    ret_val
  end

  def self.minutes_in_session(session_start_time)
    minutes = ((DateTime.now - session_start_time.to_datetime) * 24 * 60).to_i
    return minutes
  end
  def self.remove_expired_open_sessions(practice_id)
    recs = PracticeEditorSession.where(practice_id: practice_id, session_end_time: nil).where.not(session_start_time: nil)
    if recs.present?
      recs.each do |rec|
        if minutes_in_session(rec.session_start_time) > 19
          rec.destroy!
        end
      end
    end
  end
end