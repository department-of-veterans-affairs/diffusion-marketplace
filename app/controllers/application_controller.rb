class ApplicationController < ActionController::Base
  include NavigationHelper
  include Pagy::Backend
  
  protect_from_forgery with: :exception

  before_action :setup_breadcrumb_navigation
  before_action :store_user_location!, if: :storable_location?
  before_action :set_paper_trail_whodunnit
  before_action :log_in_va_user
  before_action :user_accepted_terms?
  before_action :track_visit
  before_action :track_role

  protect_from_forgery with: :exception, prepend: true

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.has_role?(:admin)
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  protected

  private

  def facilities_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
  end

  def origin_data_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
  end

  def user_accepted_terms?
    if current_user.present? && !current_user.accepted_terms && params[:controller] != 'users' && params[:action] != 'terms_and_conditions'
      redirect_to terms_and_conditions_path
    end
  end

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def log_in_va_user
    if current_user.blank? && ENV['USE_NTLM'] == 'true'
      user = User.authenticate_ldap(request.env["REMOTE_USER"])
      sign_in(user) unless user.blank?
    end
  end

  def track_visit
    ahoy.track "Site visit", {controller: request.params[:controller], action: request.params[:action], query: request.params[:query], ip_address: request.remote_ip}
  end

  def track_role
    if current_user.present?
      ahoy.track "User role", {user: current_user.email, role: current_user.user_role}
    end
  end
end
