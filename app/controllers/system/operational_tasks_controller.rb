module System
  class OperationalTasksController < ApplicationController
    before_action :check_ip_whitelist, only: [:clear_signer_cache]

    def clear_signer_cache
      begin
        Rails.cache.delete('s3_signer')
        render json: { status: 'Cache cleared successfully' }, status: :ok
      rescue => e
        render json: { error: 'Failed to clear cache', details: e.message }, status: :internal_server_error
      end
    end

    private

    def check_ip_whitelist
      return unless Rails.env.production?

      allowed_ips = ENV['WHITELISTED_IPS'].split(',')
      unless allowed_ips.include?(request.remote_ip)
        render json: { error: 'Access Denied' }, status: :forbidden
      end
    end
  end
end
