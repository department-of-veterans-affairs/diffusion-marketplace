class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :setup_breadcrumb_navigation
  before_action :store_user_location!, if: :storable_location?
  before_action :set_paper_trail_whodunnit
  before_action :log_in_va_user
  before_action :user_accepted_terms?
  before_action :track_visit

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

    def practice_by_id
      Practice.friendly.find(params[:id])
    end

    # This avoids the RecordNotFound error when params[:id] is not present
    def practice_by_practice_id
      Practice.friendly.find(params[:practice_id])
    end

    def empty_breadcrumbs
      session[:breadcrumbs] = []
    end

    def practice_breadcrumb(practice)
      session[:breadcrumbs].find { |b| b['display'] == practice.name }
    end

    def add_practice_breadcrumb(practice)
      session[:breadcrumbs] << { 'display': practice.name, 'path': practice_path(practice) }.stringify_keys
    end

    def add_checklist_breadcrumb(practice)
      session[:breadcrumbs] << { 'display': 'Planning checklist', 'path': practice_planning_checklist_path(practice) }
    end

    def remove_breadcrumb(crumb)
      session[:breadcrumbs].slice!(session[:breadcrumbs].index(crumb))
    end

    def instructions_breadcrumb
      session[:breadcrumbs].find { |b| b['display'] == 'Instructions' }
    end

    def add_instructions_breadcrumb(practice)
      session[:breadcrumbs] << { 'display': 'Edit', 'path': practice_instructions_path(practice) }
    end

    def reset_editor_breadcrumbs(practice)
      empty_breadcrumbs
      add_practice_breadcrumb(practice)
      add_instructions_breadcrumb(practice)
    end

    # practice path
    if params[:action] == 'show' && params[:controller] == 'practices'
      if practice_breadcrumb(practice_by_id).blank?
        add_practice_breadcrumb(practice_by_id)
        # If there are any duplicate breadcrumbs, delete them
      elsif practice_breadcrumb(practice_by_id).present? && practice_breadcrumb(practice_by_id).count > 1
        remove_breadcrumb(practice_breadcrumb(practice_by_id))
        add_practice_breadcrumb(practice_by_id)
      end
    end

    # practice checklist path
    if params[:action] == 'planning_checklist' && params[:controller] == 'practices'
      empty_breadcrumbs
      add_practice_breadcrumb(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Planning checklist', 'path': practice_planning_checklist_path(practice_by_practice_id) }
    end

    # practice committed path
    if params[:action] == 'committed' && params[:controller] == 'practices'
      empty_breadcrumbs
      add_practice_breadcrumb(practice_by_practice_id)
      add_checklist_breadcrumb(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Confirmation', 'path': practice_committed_path(practice_by_practice_id) }
    end

    # practice partners path
    if params[:action] == 'index' && params[:controller] == 'practice_partners'
      # empty the bread crumbs and start a new 'path'
      empty_breadcrumbs
      session[:breadcrumbs] << { 'display': 'Partners', 'path': practice_partners_path }
    end

    # practice partner show path
    if params[:action] == 'show' && params[:controller] == 'practice_partners'
      # add the practice partner to the crumbs if it's not there already
      @practice_partner = PracticePartner.friendly.find(params[:id])
      practice = Practice.find_by(slug: session[:user_return_to].split('/').pop) if session[:user_return_to].present?
      partner_breadcrumb = session[:breadcrumbs].find { |b| b['display'] == @practice_partner.name }
      add_partner_breadcrumb = session[:breadcrumbs] << { 'display': @practice_partner.name, 'path': practice_partner_path(@practice_partner) }


      if practice.present? && practice_breadcrumb(practice).blank?
        add_practice_breadcrumb(practice)
      end

      if partner_breadcrumb.blank?
        add_partner_breadcrumb
        # If there are any duplicate practice partner name breadcrumbs, delete them
      elsif partner_breadcrumb.present? && partner_breadcrumb.count > 1
        remove_breadcrumb(partner_breadcrumb)
        add_partner_breadcrumb
      end
    end

    ### PRACTICE EDITOR BREADCRUMBS ###
    # Instructions breadcrumbs
    if params[:action] == 'instructions' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
    end

    # Introduction breadcrumbs
    if params[:action] == 'introduction' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Introduction', 'path': practice_introduction_path(practice_by_practice_id) }
    end

    # Adoptions breadcrumbs
    if params[:action] == 'adoptions' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Adoptions', 'path': practice_adoptions_path(practice_by_practice_id) }
    end

    # Overview breadcrumbs
    if params[:action] == 'overview' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Overview', 'path': practice_overview_path(practice_by_practice_id) }
    end

    # Implementation breadcrumbs
    if params[:action] == 'implementation' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Implementation', 'path': practice_implementation_path(practice_by_practice_id) }
    end

    # Contact breadcrumbs
    if params[:action] == 'contact' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Contact', 'path': practice_contact_path(practice_by_practice_id) }
    end

    # About breadcrumbs
    if params[:action] == 'about' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'About', 'path': practice_about_path(practice_by_practice_id) }
    end
  end

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

end
