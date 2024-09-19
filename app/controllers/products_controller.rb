class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :search, :index]
  before_action :set_product, only: [:show, :update, :description, :intrapreneur]
  before_action :check_product_permissions, only: [:show, :update, :description, :intrapreneur]

  def description
    render 'products/form/description'
  end

  def intrapreneur
    render 'products/form/intrapreneur'
  end

  def show
    render 'products/show'
  end

  def update
    submitted_product_data = product_params
    submitted_page = submitted_product_data.delete(:submitted_page)
    @product.assign_attributes(submitted_product_data)

    if @product.changed? || va_employees_updated
      unless @product.save
        flash[:error] = @product.errors.map {|error| error.options[:message]}.join(', ')
        redirect_to send("product_#{submitted_page}_path", @product) || admin_product_path(@product)
        return
      end
    end

    # once subsequent editor pages exist render the next page using submitted_page upon successful update
    flash[:success] = 'Product was successfully updated.'
    redirect_to send("product_#{submitted_page}_path", @product) || admin_product_path(@product)
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
      :duns,
      :shipping_timeline_estimate,
      :origin_story,
      :submitted_page,
      va_employees_attributes: [:id, :name, :role, :_destroy]
      )
  end

  def check_product_permissions
    unless current_user.has_role?(:admin) || @product&.user_id == current_user.id
      unauthorized_response
    end
  end

  def va_employees_updated
    @product.va_employees.any? { |employee| employee.changed? || employee.marked_for_destruction? } ||
      @product.va_employees.length != @product.va_employees.reject(&:marked_for_destruction?).length
  end
end
