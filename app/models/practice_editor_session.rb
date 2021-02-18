class PracticeEditorSession < ApplicationRecord
  belongs_to :practice

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


  def self.lock_practice_for_user(user_id, practice_id)
    #TODO clean up???
    PracticeEditorSession.create user_id: user_id, practice_id: practice_id, session_start_time: DateTime.now, session_end_time: nil
  end
  def self.locked_by(rec_id, include_time = true)
    rec = PracticeEditorSession.find_by_id(rec_id)
    user_id = rec.user_id
    user = User.find_by_id(user_id)
    first_name = user.first_name.nil? ? "?" : user.first_name
    last_name = user.last_name.nil? ? "?" : user.last_name
    ret_val = first_name + " " + last_name
    ret_val += " @" + rec.session_start_time.to_s if include_time
    ret_val
  end
  def self.locked_by_user(rec_id)
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

  def self.monitor_editing_session(practice_id, user_id)
    #TODO update session record with process ID...
    session_rec = PracticeEditorSession.where(practice_id: practice_id, user_id: user_id, session_end_time: nil, process_id: nil).order("session_start_time DESC").first()
    Thread.new do
      if !session_rec.blank?
        session_rec.process_id = Thread.current.object_id.to_i
        session_rec.save
      else
        Thread.exit
        return
      end
        monitor_session(practice_id, user_id, session_rec.id)
    end
  end
  def self.monitor_session(practice_id, user_id, session_rec_id)
    loop do
      session_rec = PracticeEditorSession.where(practice_id: practice_id, user_id: user_id, session_end_time: nil).order("session_start_time DESC").first()
      if session_rec.blank?
        Thread.exit
      end
      sleep 50
      diff = minutes_in_session(session_rec.session_start_time)
      is_published = Practice.find_by_id(practice_id).published
      puts 'session_start_time: ' + session_rec.session_start_time.to_s
      puts 'diff from now: ' + diff.to_s
      puts 'rec_id: ' + session_rec_id.to_s
      puts 'process id: ' + session_rec.process_id.to_s
      puts 'thread_id: ' + Thread.current.object_id.to_s
      puts practice_id.to_s + ", " + user_id.to_s
      #TODO: set back to diff > 14 .set to 0 only for testing.. bj_2_10_2021
      if (is_published && diff > 14) || (!is_published && diff > 28)
        rec = PracticeEditorSession.find_by_id(session_rec_id)
        if !rec.blank?
          if rec.session_end_time.blank?
            rec.session_end_time = DateTime.now
            rec.save
          end
        end
        puts 'session end ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        Thread.exit
      end
    end
  end

  def self.extend_current_session(user_id, practice_id, practice)
    rec = PracticeEditorSession.where(practice_id: practice_id, user_id: user_id, session_end_time: nil).order("session_start_time DESC").first()
    if !rec.blank?
      rec.session_start_time = DateTime.now
      rec.save
      return true
    else
      return false
    end
  end

  def self.close_current_session(user_id, practice_id)
    rec = PracticeEditorSession.where(practice_id: practice_id, user_id: user_id, session_end_time: nil).order("session_start_time DESC").first()
    if !rec.blank?
      rec.session_end_time = DateTime.now
      rec.save
    end
  end


  def self.get_minutes_remaining_in_session(user_id, practice_id, is_published)
    rec_session = PracticeEditorSession.where(practice_id: practice_id, user_id: user_id, session_end_time: nil).order("session_start_time DESC").first()
    if rec_session.blank?
      return 0
    end
    #TODO: change this back to 15......... set to 2...? only for testing..... bj_2_10_2021
    if is_published
      ret_val =  15 - minutes_in_session(rec_session.session_start_time).to_i
    else
      ret_val =  30 - minutes_in_session(rec_session.session_start_time).to_i
    end
    ret_val
  end

  def self.minutes_in_session(session_start_time)
    minutes = ((DateTime.now - session_start_time.to_datetime) * 24 * 60).to_i
    return minutes
  end
  def self.get_practice_record(practice_id)
    practice_rec = Practice.find_by_id(practice_id)
    if !practice_rec.blank?
      return practice_rec
    else
      return nil
    end
  end
  def self.check_session_info(practice)
    ctr = 0
    recs = PracticeEditorSession.where(practice_id: practice.id).where.not(session_end_time: nil).order("session_start_time DESC")
    if !recs.blank? && recs.count > 1
      recs.each do |rec|
        if ctr > 0
          if ((practice.published && minutes_in_session(rec.session_start_time) > 19) || (!practice.published && minutes_in_session(rec.session_start_time) > 34))
            rec.destroy!
            rec.save
          end
        end
        ctr += 1
      end
    end
    remove_expired_open_sessions(practice.id)
  end
  def self.remove_expired_open_sessions(practice_id)
    recs = PracticeEditorSession.where(practice_id: practice_id, session_end_time: nil).where.not(session_start_time: nil)
    if !recs.blank?
      recs.each do |rec|
        if minutes_in_session(rec.session_start_time) > 19
          rec.destroy!
          rec.save
        end
      end
    end
  end
end