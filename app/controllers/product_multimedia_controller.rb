class ProductMultimediaController < ApplicationController
  before_action :authenticate_user!, except: [:download]
  before_action :set_product_resource, only: [:download]

  def download
    if @product.published?
      handle_enabled_practice
    elsif current_user
      handle_user_with_unpublished_product
    else
      unauthorized_response
    end
  end

  private

  def set_product_resource
    @product = Product.find_by(id: resource_params[:product_id])

    if @product
      @product_resource = @product.practice_multimedia.find_by(id: resource_params[:id])
    end

    unless @product_resource
      render plain: "Product or Resource not found", status: :not_found and return
    end
  end

  def resource_params
    params.permit(:product_id, :id, :resource_type)
  end

  def handle_enabled_practice
    if @product.is_public || current_user
      redirect_to @product_resource.attachment_s3_presigned_url, allow_other_host: true
    else
      unauthorized_response
    end
  end

  def handle_user_with_unpublished_product
    if check_user_product_permissions
      redirect_to @product_resource.attachment_s3_presigned_url, allow_other_host: true
    else
      unauthorized_response
    end
  end

  def check_user_product_permissions
    current_user.has_role?(:admin) || @product.user_id == current_user.id || is_user_an_editor_for_innovation(@product, current_user)
  end
end
