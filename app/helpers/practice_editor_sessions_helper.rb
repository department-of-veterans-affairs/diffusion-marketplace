module PracticeEditorSessionsHelper
  def session_username(session)
    if session.user.present? && session.user.full_name.present?
      username = session.user.full_name === 'User' ? session.user.email : session.user.full_name
      username += " (Site Admin)" if session.user.roles.find_by(name: 'admin').present?
      username
    else
      ''
    end
  end
end
