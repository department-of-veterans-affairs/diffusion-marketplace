class SaveProductService
  include CropperUtils
  attr_reader :product, :multimedia_params, :product_params, :errors, :product_updated

  def initialize(product:, product_params:, multimedia_params: nil)
    @product = product
    @multimedia_params = multimedia_params
    @product_params = product_params
    @errors = []
    @product_updated = false
  end

  def call
    ActiveRecord::Base.transaction do
      handle_product_params if @product_params.present?
      handle_multimedia_params if @multimedia_params.present?

      merged_params = @product_params.merge(@multimedia_params)
      @product.assign_attributes(merged_params)

      handle_main_display_image_cropping if main_display_image_cropping_params_present?(merged_params)

      if @product.changed? || product_associations_changed? || @product_updated
        unless @product.save
          collect_errors
          raise ActiveRecord::Rollback
        end
        @product_updated = true
      else
        @product_updated = false
      end
    end

    @product_updated
  rescue StandardError => e
    @errors << e.message
    false
  end

  private

  def handle_product_params
    if @product_params[:category].present?
      @product_updated = update_category_practices(@product_params[:category]) || @product_updated
      @product_params.delete(:category)
    end

    if @product_params[:delete_main_display_image] == 'true'
      @product.remove_main_display_image(@product_params)
      @product_updated = true
      @product_params.delete(:delete_main_display_image)
    end
  end

  def handle_multimedia_params
    @multimedia_params = process_multimedia_params(@multimedia_params)
    @product_updated = update_multimedia(@multimedia_params) || @product_updated
  end

  def handle_main_display_image_cropping
    @product.main_display_image.reprocess!
    @product_updated = true
  end

  def process_multimedia_params(params)
    PracticeMultimedium.resource_types.each do |rt|
      params['practice_multimedia_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0])
    end
    params
  end

  def main_display_image_cropping_params_present?(params)
    %w[crop_x crop_y crop_w crop_h].any? { |param| params[param].present? }
  end

  def product_associations_changed?
    @product.va_employees.any? { |record| record.changed? || record.marked_for_destruction? } ||
      @product.va_employees.length != product.va_employees.reject(&:marked_for_destruction?).length ||
      @product.practice_multimedia.any? { |record| record.changed? || record.marked_for_destruction? } ||
      @product.practice_multimedia.length != product.practice_multimedia.reject(&:marked_for_destruction?).length
  end

  def update_category_practices(category_params)
    changed = false

    category_keys = category_params ? category_params.keys.map { |key| key.gsub("_resource", "") } : []
    current_category_ids = @product.categories.pluck(:id)
    product_category_practices = @product.category_practices

    missing_category_ids = category_keys.map(&:to_i) - current_category_ids
    missing_category_ids.delete(0) if missing_category_ids.count
    if missing_category_ids.any?
      missing_category_ids.each do |category_id|
        product_category_practices.create!(category_id: category_id)
      end
      changed = true
    end

    practices_to_remove = product_category_practices.joins(:category).where.not(categories: { id: category_keys })
    if practices_to_remove.any?
      practices_to_remove.destroy_all
      changed = true
    end

    changed
  end

  def update_multimedia(multimedia_params)
    changed = false
    multimedia_resources = multimedia_params["practice_multimedia_attributes"]

    if multimedia_resources
      multimedia_resources.each do |r|
        if is_cropping?(r[1]) && r[1][:_destroy] == 'false' && r[1][:id].present?
          r_id = r[1][:id].to_i
          record = @product.practice_multimedia.find(r_id)
          reprocess_attachment(record, r[1])
          changed = true
        end
      end
    end
    changed
  end

  def collect_errors
    @errors.concat(@product.errors.full_messages)
  end
end
