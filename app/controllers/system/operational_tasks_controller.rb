module System
  class OperationalTasksController < ApplicationController
    skip_before_action  :verify_authenticity_token,
                        :setup_breadcrumb_navigation, 
                        :reload_turbolinks, 
                        :store_user_location!, 
                        :set_paper_trail_whodunnit, 
                        :log_in_va_user, 
                        :user_accepted_terms?, 
                        :set_visit_props, 
                        :set_visitor_props, 
                        only: [:clear_signer_cache]
    before_action :custom_verify_authenticity_token, only: [:clear_signer_cache]

    def clear_signer_cache
      begin
        Rails.cache.delete('s3_signer')
        render json: { status: 'Cache cleared successfully' }, status: :ok
      rescue => e
        render json: { error: 'Failed to clear cache', details: e.message }, status: :internal_server_error
      end
    end

    private

    def custom_verify_authenticity_token
 
      return unless Rails.env.production? || Rails.env.development?

      secure_token = ENV['CLEAR_SIGNER_CACHE_TOKEN']
      authorization_header = request.headers['Authorization']

      unless authorization_header && ActiveSupport::SecurityUtils.secure_compare(authorization_header, "Bearer #{secure_token}")
        render json: { error: 'Access Denied' }, status: :forbidden
      end
    end
  end
end
