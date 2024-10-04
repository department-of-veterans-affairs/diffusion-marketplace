class ProductsController < ApplicationController
  include InnovationControllerMethods
  before_action :authenticate_user!, except: [:show, :search, :index]
  before_action :set_product, only: [:show, :update, :description, :intrapreneur, :multimedia]
  before_action :check_product_permissions, only: [:show, :update, :description, :intrapreneur, :multimedia]

  def description
    @categories = Category.prepared_categories_for_practice_editor(current_user.has_role?(:admin))
    render 'products/form/description'
  end

  def intrapreneur
    render 'products/form/intrapreneur'
  end

  def multimedia
    @show_return_to_top = true
    render 'products/form/multimedia'
  end

  def show
    @search_terms = @product.categories.get_category_names
    render 'products/show'
  end

  def update
    submitted_page = navigation_params[:submitted_page]
    service = SaveProductService.new(
      product: @product,
      product_params: params[:product].nil? ? {} : product_params,
      multimedia_params: params[:practice].nil? ? {} : multimedia_params
    )

    product_updated = false

    if params[:practice].present?
      submitted_product_data = process_multimedia_params(multimedia_params)
      product_updated = @product.update_multimedia(multimedia_params)
    elsif current_endpoint == 'description'
      product_updated = @product.update_category_practices(product_params[:category])
      submitted_product_data.delete(:category)
    end

    @product.assign_attributes(submitted_product_data)
    product_updated = (@product.changed? || product_associations_changed?) ? true : product_updated

    if product_updated
      unless @product.save
        flash[:error] = @product.errors.map {|error| error.options[:message]}.join(', ')
        redirect_to send("product_#{current_endpoint}_path", @product) || admin_product_path(@product)
        return
      end
    end

    notice = product_updated ? "Product was successfully updated." : nil
    if params[:next]
      redirect_to send("product_#{Product::PRODUCT_EDITOR_NEXT_PAGE[current_endpoint.to_sym]}_path", @product), notice: notice
      return
    else
      next_page = params[:next] ? "#{Product::PRODUCT_EDITOR_SLUGS[submitted_page.to_sym]}_" : nil
      redirect_to send("product_#{next_page}path", @product)
    end
  rescue => e
    logger.error "Product update failed: #{e.message}"
    flash[:error] = "An unexpected error occurred: #{e.message}"
    redirect_to send("product_#{submitted_page}_path", @product) || admin_product_path(@product)
  end

  private

  def set_product
    product_id = params[:id] || params[:product_id]
    @product = Product.friendly.find(product_id)
  end

  def product_params
    params.require(:product).permit(
      :name,
      :tagline,
      :description,
      :item_number,
      :vendor,
      :vendor_link,
      :duns,
      :shipping_timeline_estimate,
      :price,
      :origin_story,
      :main_display_image,
      :crop_x,
      :crop_y,
      :crop_w,
      :crop_h,
      :delete_main_display_image,
      va_employees_attributes: [:id, :name, :role, :_destroy],
      category: permitted_dynamic_keys(params[:product][:category]),
    )
  end

  def multimedia_params
    params.require(:practice).permit(
      practice_multimedia_attributes: permitted_dynamic_keys(params[:practice][:practice_multimedia_attributes])
    )
  end

  def navigation_params
    params.permit(:submitted_page, :next)
  end

  def check_product_permissions
    unless @product.published? || current_user&.has_role?(:admin) || @product&.user_id == current_user&.id
      unauthorized_response
    end
  end
end
