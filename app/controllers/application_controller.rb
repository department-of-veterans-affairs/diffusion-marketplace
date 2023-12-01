class ApplicationController < ActionController::Base
  include NavigationHelper
  include StatusHelper
  include Pagy::Backend

  protect_from_forgery with: :exception

  before_action :setup_breadcrumb_navigation
  before_action :reload_turbolinks
  before_action :store_user_location!, if: :storable_location?
  before_action :set_paper_trail_whodunnit
  before_action :log_in_va_user
  before_action :user_accepted_terms?
  before_action :set_visit_props
  before_action :set_visitor_props

  protect_from_forgery with: :exception, prepend: true

  def reload_turbolinks
    @reload_turbolinks = revision.present? && Rails.cache.redis.keys('revision').present? ? revision != cached_revision : true
    reset_revision_cache if @reload_turbolinks
  end

  def authenticate_active_admin_user!
    authenticate_user!
    if current_user.present?
      is_admin = current_user.has_role?(:admin)
      terms_accepted = current_user.accepted_terms
      flash[:alert] = "Unauthorized Access!" if !is_admin
      flash[:alert] = "Accept terms and conditions" if !terms_accepted

      if !is_admin || !terms_accepted
        redirect_to root_path
      end
    end
  end

  def after_sign_in_path_for(resource)
    session[:download_info] ? download_and_redirect_practice_resources_path : super
  end

  def signed_resource
    # In order to circumvent making a request to AWS for tests, we can return the Paperclip attachment's 'url'.
    # If there isn't one, the default value is set to an empty string.
    if Rails.env.test?
      render plain: params[:url] || ''
      return
    end

    unless params[:path]
      render plain: "Missing path parameter", status: :bad_request
      return
    end

    parsed_path = sanitize_path(params[:path])
    render plain: parsed_path.blank? ? "Invalid path" : s3_signer.presigned_get_url(object_key: parsed_path)
  rescue => e
    Rails.logger.error "Error in signed_resource: #{e.message}. Backtrace: #{e.backtrace.join("\n")}"
    render plain: "An error occurred: #{e.message}", status: :internal_server_error
  end

  protected

  private

  def sanitize_path(path)
    parser = URI::Parser.new
    parser.escape(path.sub('/', '')).gsub(/[\(\)\*]/) {|m| "%#{m.ord.to_s(16).upcase}" }
  end

  def s3_signer
    Rails.cache.fetch('s3_signer', expires_in: 45.minutes) do
      s3_bucket = Aws::S3::Bucket.new(ENV['S3_BUCKET_NAME'])
      WT::S3Signer.for_s3_bucket(s3_bucket, expires_in: 45.minutes)
    end
  end

  def origin_data_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
  end

  def user_accepted_terms?
    @force_terms_and_conditions_modal = current_user.present? && !current_user.accepted_terms
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
    if current_user.blank?
      user = User.authenticate_ldap(request.env["REMOTE_USER"]) if request.env["REMOTE_USER"].present?
      # if a user is found, log them in and set the user_type to 'ntlm' in the session
      if user.present?
        session[:user_type] = 'ntlm'
        sign_in(user)
      # if not, set the user_type to 'guest' in the session
      else
        session[:user_type] = 'guest'
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
