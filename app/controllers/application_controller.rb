class ApplicationController < ActionController::Base
  include NavigationHelper
  include Pagy::Backend
  include UserUtils

  protect_from_forgery with: :exception

  before_action :setup_breadcrumb_navigation
  before_action :store_user_location!, if: :storable_location?
  before_action :set_paper_trail_whodunnit
  before_action :user_accepted_terms?
  before_action :set_visit_props
  before_action :set_visitor_props
  before_action :check_for_ntlm
  before_action :set_user_param

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

  def set_user_param
    if current_user.blank?
      # check to see if the user is using NTLM
      user = User.authenticate_ldap(request.env["REMOTE_USER"])
      # if so, log them in and set the user_type to 'ntlm' in the session
      if user.present?
        session[:user_type] = 'ntlm'
        sign_in(user)
      # if not, set the user_type to 'guest' in the session
      else
        session[:user_type] = 'guest'
      end
    elsif current_user.present?
      if params[:id] === 'a-public-practice'
        session[:user_type] = 'test' if session[:user_type] === 'guest'
      else
        session[:user_type] = 'public' if session[:user_type] === 'guest'
      end
    end
  end

  def set_visit_props
    @visit_properties = {controller: request.params[:controller], action: request.params[:action], query: request.params[:query], ip_address: request.remote_ip, timestamp: Time.now.utc}
    if request.params[:page_group_friendly_id]
      @visit_properties[:page_group] = request.params[:page_group_friendly_id]
    end
    if request.params[:page_slug]
      @visit_properties[:page_slug] = request.params[:page_slug]
    end
  end

  def set_visitor_props
    if current_user.present?
      @visitor_properties = {user: current_user.email, role: current_user.user_role}
    end
  end
end