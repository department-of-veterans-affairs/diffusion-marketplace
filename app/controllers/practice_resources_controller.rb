class PracticeResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:download]
  before_action :set_practice_and_resource, only: [:download]

  def download
    if @practice_resource
      redirect_to @practice_resource.attachment_s3_presigned_url
    else
      render plain: "Resource not found", status: :not_found
    end
  end

  private

  def set_practice_and_resource
    @practice = Practice.find_by(id: params[:practice_id])
    if @practice
      @practice_resource = @practice.practice_resources.find_by(id: params[:id])
    end
    unless @practice_resource
      render plain: "Practice or Resource not found", status: :not_found and return
    end
  end
end
