class ProductsController < ApplicationController
  include CropperUtils, InnovationControllerMethods
  before_action :authenticate_user!, except: [:show, :search, :index]
  before_action :set_product, only: [:show, :update, :description, :intrapreneur, :multimedia]
  before_action :check_product_permissions, only: [:show, :update, :description, :intrapreneur, :multimedia]

  def description
    render 'products/form/description'
  end

  def intrapreneur
    render 'products/form/intrapreneur'
  end

  def show
    render 'products/show'
  end

  def multimedia
    render 'products/form/multimedia'
  end

  def update
    submitted_product_data = product_params
    submitted_page = submitted_product_data.delete(:submitted_page)

    if params[:practice].present?
      submitted_product_data = process_multimedia_params(multimedia_params)
      handle_multimedia_updates
    end

    @product.assign_attributes(submitted_product_data)

    if @product.changed? || product_associations_changed?
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
      va_employees_attributes: [:id, :name, :role, :_destroy],
    )
  end

  def multimedia_params
    params.require(:practice).permit(
      practice_multimedia_attributes: permitted_dynamic_keys(params[:practice][:practice_multimedia_attributes])
    )
  end

  def check_product_permissions
    unless current_user&.has_role?(:admin) || @product&.user_id == current_user&.id
      unauthorized_response
    end
  end

  def product_associations_changed?
    @product.va_employees.any? { |record| record.changed? || record.marked_for_destruction? } ||
      @product.va_employees.length != @product.va_employees.reject(&:marked_for_destruction?).length ||
      @product.practice_multimedia.any? { |record| record.changed? || record.marked_for_destruction? } ||
      @product.practice_multimedia.length != @product.practice_multimedia.reject(&:marked_for_destruction?).length
  end

  def handle_multimedia_updates
    multimedia_resources = multimedia_params["practice_multimedia_attributes"]
    if multimedia_resources
      multimedia_resources.each do |r|
        if is_cropping?(r[1]) && r[1][:_destroy] == 'false' && r[1][:id].present?
          r_id = r[1][:id].to_i
          record = @product.practice_multimedia.find(r_id)
          reprocess_attachment(record, r[1])
        end
      end
    end
  end

  def process_multimedia_params(params)
    PracticeMultimedium.resource_types.each do |rt|
      params['practice_multimedia_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0])
    end
    params
  end
end
