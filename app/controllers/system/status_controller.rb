module System
  class StatusController < ApplicationController
    before_action :authenticate_active_admin_user!

    def index
      @deployed_at = deployed_at
      @revision = revision
    end

    private

    def revision_file
      File.new("REVISION") rescue nil
    end

    def deployed_at
      revision_file.mtime rescue nil
    end

    def revision
      revision_file.read rescue nil
    end
  end
end
