module System
  class StatusController < ApplicationController
    include StatusHelper
    before_action :authenticate_active_admin_user!

    def index
      @deployed_at = deployed_at
      @revision = revision
      @refreshed_db_with = refreshed
    end

    private

    def deployed_at
      get_current_revision_file.mtime rescue nil
    end

    def refreshed_file
      File.new("REFRESHED_DB_WITH") rescue nil
    end

    def refreshed
      refreshed_file.read rescue nil
    end

  end
end
