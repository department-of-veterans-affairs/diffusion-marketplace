class PageResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:download]
  before_action :set_page_resource

  def download
    if @page.published
      handle_published_page
    elsif current_user
      handle_user_with_unpublished_practice
    else
      unauthorized_response
    end
  end

  private

  def set_page_resource
    @page = Page.find_by(id: resource_params[:page_id])

    if @page
      @page_resource =  @page.page_components.find_by(component_id: resource_params[:id]).component
    else
      render plain: "Page not found", status: :not_found and return
    end
  end

  def resource_params
    params.permit(:page_id, :id)
  end

  def handle_published_page
    if @page.is_public || current_user
      redirect_to @page_resource.attachment_s3_presigned_url, allow_other_host: true
    else
      unauthorized_response
    end
  end

  def handle_user_with_unpublished_practice
    if current_user&.has_role?(:admin)
      redirect_to @page_resource.attachment_s3_presigned_url, allow_other_host: true
    else
      unauthorized_response
    end
  end
end
