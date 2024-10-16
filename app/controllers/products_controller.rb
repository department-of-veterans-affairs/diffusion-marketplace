class ProductsController < ApplicationController
  include InnovationControllerMethods, UsersHelper
  before_action :authenticate_user!, except: [:show, :search, :index]
  before_action :set_product, only: [:show, :update, :editors, :description, :intrapreneur, :multimedia]
  before_action :check_product_permissions, only: [:show, :update, :editors, :description, :intrapreneur, :multimedia]
  before_action :set_return_to_top_flag, only: [:show, :editors, :description, :intrapreneur, :multimedia]

  def editors
    @editors = PracticeEditor.where(innovable: @product).order(created_at: :asc)
    render 'products/form/editors'
  end

  def description
    @categories = Category.prepared_categories_for_practice_editor(current_user.has_role?(:admin))
    render 'products/form/description'
  end

  def intrapreneur
    render 'products/form/intrapreneur'
  end

  def show
    @search_terms = @product.categories.get_category_names
    render 'products/show'
  end

  def multimedia
    @show_return_to_top = true
    render 'products/form/multimedia'
  end

  def update
    submitted_page = navigation_params[:submitted_page]

    service = SaveProductService.new(
      product: @product,
      product_params: params[:product].nil? ? {} : product_params,
      multimedia_params: params[:practice].nil? ? {} : multimedia_params
    )
    service.call
    if service.errors.empty?
      notice =  if service.added_editor
                  "Editor was added to the list. Product was successfully updated."
                elsif service.editor_removed
                  "Editor was removed from the list. Product was successfully updated."
                elsif service.product_updated
                  "Product was successfully updated."
                else
                  nil
                end

      next_page = params[:next] ? Product::PRODUCT_EDITOR_NEXT_PAGE[submitted_page] : submitted_page
      redirect_to send("product_#{next_page}_path", @product), notice: notice
    else
      flash[:error] = service.errors.any? ? service.errors.join(', ') : "An unexpected error occurred."
      redirect_back(fallback_location: admin_product_path(@product))
    end
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
      :main_display_image_caption,
      :main_display_image_alt_text,
      :crop_x,
      :crop_y,
      :crop_w,
      :crop_h,
      :delete_main_display_image,
      :add_editor,
      :delete_editor,
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

  def set_return_to_top_flag
    @show_return_to_top = true
  end

  def check_product_permissions
    unless @product.published? || current_user&.has_role?(:admin) || @product&.user_id == current_user&.id
      unauthorized_response
    end
  end
end
