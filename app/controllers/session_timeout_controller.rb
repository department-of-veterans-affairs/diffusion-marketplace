# implementation source: https://medium.com/codex/user-session-inactivity-timeout-with-rails-and-devise-7269ac3a8213
class SessionTimeoutController < Devise::SessionsController
  prepend_before_action :skip_timeout, only: [:check_session_timeout, :render_timeout]

  def check_session_timeout
    response.headers["Etag"] = "" # clear etags to prevent caching
    render plain: ttl_to_timeout, status: :ok
  end

  def render_timeout
    redirect_pathname = params[:path]
    reset_session
    sign_out(current_user)
    url_text = redirect_pathname === '/' ? nil : 'Return to where you left off.'
    redirect_to root_path, :flash => { alert: 'Your session has expired.', url: redirect_pathname, url_text: url_text }
  end

  private
  def ttl_to_timeout
    return 0 if user_session.blank?
    Devise.timeout_in - (Time.now.utc - last_request_time).to_i
  end

  def last_request_time
    user_session["last_request_at"].presence || 0
  end

  def skip_timeout
    request.env["devise.skip_trackable"] = true
  end
end
