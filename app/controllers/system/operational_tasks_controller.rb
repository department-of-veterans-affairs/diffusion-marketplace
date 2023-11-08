module System
  class OperationalTasksController < ApplicationController
    before_action :check_token_authentication, only: [:clear_signer_cache]

    def clear_signer_cache
      begin
        Rails.cache.delete('s3_signer')
        render json: { status: 'Cache cleared successfully' }, status: :ok
      rescue => e
        render json: { error: 'Failed to clear cache', details: e.message }, status: :internal_server_error
      end
    end

    private

    def check_token_authentication
      return unless Rails.env.production?

      secure_token = ENV['CLEAR_SIGNER_CACHE_TOKEN']
      authorization_header = request.headers['Authorization']

      unless authorization_header && ActiveSupport::SecurityUtils.secure_compare(authorization_header, "Bearer #{secure_token}")
        render json: { error: 'Access Denied' }, status: :forbidden
      end
    end
  end
end
