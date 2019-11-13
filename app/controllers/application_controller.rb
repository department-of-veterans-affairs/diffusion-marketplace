class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception

  before_action :setup_breadcrumb_navigation
  before_action :store_user_location!, if: :storable_location?
  before_action :set_paper_trail_whodunnit
  before_action :log_in_va_user
  before_action :user_accepted_terms?

  protect_from_forgery with: :exception, prepend: true

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.has_role?(:admin)
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  protected

  def setup_breadcrumb_navigation
    session[:breadcrumbs] = session[:breadcrumbs] || []

    # reset if home page
    if params[:action] == 'index' && params[:controller] == 'home'
      session[:breadcrumbs] = []
      return
    end

    url = URI::parse(request.referer || '')
    # search 'path'
    if params[:action] == 'index' && params[:controller] == 'practices'
      # empty the bread crumbs and start a new path
      session[:breadcrumbs] = []
      session[:breadcrumbs] << {'display': 'Practices', 'path': '/practices'}
    end

    # add the search breadcrumb if there is a search query going to the practice page
    if params[:action] == 'show' && params[:controller] == 'practices' && url.path.include?('search') && (url.query.present? && url.query.include?('query='))
      search_breadcrumb = session[:breadcrumbs].find { |bc| bc['display'] == 'Search' || bc[:display] == 'Search'}
      search_breadcrumb['path'] = "#{url.path}?#{url.query}" if search_breadcrumb.present?
      session[:breadcrumbs] << {'display': 'Search', 'path': "#{url.path}?#{url.query}"} if search_breadcrumb.blank?
    end

    # practice partners path
    if params[:action] == 'index' && params[:controller] == 'practice_partners'
      # empty the bread crumbs and start a new 'path'
      session[:breadcrumbs] = []
      session[:breadcrumbs] << {'display': 'Partners', 'path': practice_partners_path}
    end

    # practice partner show path
    if params[:action] == 'show' && params[:controller] == 'practice_partners'
      # add the practice partner to the crumbs if it's not there already
      @practice_partner = PracticePartner.friendly.find(params[:id])
      unless session[:breadcrumbs].find {|b| b['display'] == @practice_partner.name}.present?
        session[:breadcrumbs] << {'display': @practice_partner.name, 'path': practice_partner_path(@practice_partner)}
      end
    end
  end

  private

  def facilities_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
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

end
