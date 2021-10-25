module SessionHelper
  def is_user_a_guest?
    vaec_environment = ENV['VAEC_ENV']
    (session[:user_type] === 'guest' && vaec_environment === 'true') || (current_user.blank? && vaec_environment.nil?)
  end
end