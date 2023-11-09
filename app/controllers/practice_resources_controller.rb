class PracticeResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:download]
  before_action :set_practice_resource, only: [:download]

  def download
    redirect_to @practice_resource.attachment_s3_presigned_url
  end

  private

  def set_practice_resource
    @practice_resource = PracticeResource.find(params[:id])
  end
end