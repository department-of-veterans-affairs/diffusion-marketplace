class SaveProductService
  include CropperUtils, UserUtils
  attr_reader :product,
              :multimedia_params,
              :product_params,
              :errors,
              :product_updated,
              :added_editor,
              :editor_removed

  def initialize(product:, product_params:, multimedia_params:)
    @product = product
    @multimedia_params = multimedia_params
    @product_params = product_params
    @errors = []
    @product_updated = false
    @editor_added = false
    @editor_removed = false
  end

  def call
    success = false
    ActiveRecord::Base.transaction do
      handle_product_params if @product_params.present?
      handle_multimedia_params if @multimedia_params.present?
      merged_params = @product_params.merge(@multimedia_params)
      @product.assign_attributes(merged_params)

      handle_main_display_image_cropping if main_display_image_cropping_params_present?(merged_params)

      if (@product.changed? || product_associations_changed?) && @errors.empty?
        @product_updated = true
      end

      if @product_updated
        unless @product.save
          collect_errors
          raise ActiveRecord::Rollback if @errors.any?
        end

        send_editor_invitation if @added_editor
        success = true
      end
    end
    success
  end

  private

  def handle_product_params
    if @product_params[:category].present?
      @product_updated = update_category_practices(@product_params[:category]) || @product_updated
      @product_params.delete(:category)
    end

    if @product_params[:delete_main_display_image] == 'true'
      remove_main_display_image(@product_params)
      @product_updated = true
      @product_params.delete(:delete_main_display_image)
    end

    if @product_params[:add_editor].present?
      @product_updated = add_editor(@product_params[:add_editor]) || @product_updated
      @product_params.delete(:add_editor)
    end

    if @product_params[:delete_editor].present?
      @product_updated = delete_editor(@product_params[:delete_editor]) || @product_updated
      @product_params.delete(:delete_editor)
    end

    if @product_params[:practice_partner_practices_attributes].present?
      @product_updated = update_practice_partners(@product_params[:practice_partner_practices_attributes])
      @product_params.delete(:practice_partner_practices_attributes)
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
      @product.practice_multimedia.length != product.practice_multimedia.reject(&:marked_for_destruction?).length ||
      @product.practice_editors.any? { |record| record.changed? || record.marked_for_destruction? } ||
      @product.practice_editors.length != product.practice_editors.reject(&:marked_for_destruction?).length
  end

  def update_category_practices(category_params)
    changed = false

    category_keys = category_params ? category_params.keys.map { |key| key.gsub("_resource", "") } : []
    current_category_ids = @product.categories.pluck(:id)
    product_category_practices = @product.category_practices

    missing_category_ids = category_keys.map(&:to_i) - current_category_ids
    missing_category_ids.delete(0) if missing_category_ids.count > 0

    if missing_category_ids.any?
      missing_category_ids.each do |category_id|
        category = Category.find_by(id: category_id)
        if category
          begin
            product_category_practices.create!(category: category)
            changed = true
          rescue ActiveRecord::RecordInvalid => e
            @errors << "Failed to add category '#{category.name}': #{e.message}"
            return false
          end
        else
          @errors << "Category with ID #{category_id} not found."
          return false
        end
      end
    end

    cat_practices_to_remove = product_category_practices.joins(:category).where.not(categories: { id: category_keys })
    if cat_practices_to_remove.any?
      cat_practices_to_remove.each do |cat_practice|
        category = cat_practice.category
        begin
          cat_practice.destroy!
          changed = true
        rescue ActiveRecord::RecordNotDestroyed => e
          @errors << "Failed to remove category '#{category.name}': #{e.message}"
          return false
        end
      end
    end

    changed
  end

  def update_multimedia(multimedia_params)
    changed = false
    multimedia_resources = multimedia_params["practice_multimedia_attributes"]

    if multimedia_resources
      multimedia_resources.each do |_, attributes|
        if is_cropping?(attributes) && attributes[:_destroy] == 'false' && attributes[:id].present?
          begin
            record = @product.practice_multimedia.find(attributes[:id].to_i)
            reprocess_attachment(record, attributes)
            changed = true
          rescue ActiveRecord::RecordNotFound
            @errors << "There was an error processing a resource"
            return false
          end
        end
      end
    end
    changed
  end

  def remove_main_display_image(params)
    if params[:delete_main_display_image].present? && params[:delete_main_display_image] == 'true'
      @product.main_display_image = nil
    else
      false
    end
  end

  def add_editor(editor_email)
    email = editor_email.downcase
    user = User.find_by(email: email)

    unless user
      @errors << "No user found with the email \"#{email}\""
      return false
    end

    if @product.practice_editors.exists?(user: user)
      @errors << "A user with the email \"#{user.email}\" is already an editor for this product"
      return false
    end

    practice_editor = @product.practice_editors.build(user: user, email: user.email)
    if practice_editor.valid?
      @added_editor = practice_editor
      true
    else
      @errors.concat(practice_editor.errors.full_messages)
      false
    end
  end

  def delete_editor(editor_id)
    editor = @product.practice_editors.find_by(id: editor_id)

    if editor.nil?
      @errors << "User is not an editor for this practice"
      return false
    end

    if @product.practice_editors.count <= 1
      @errors << "At least one editor is required"
      return false
    end

    if @product.practice_editors.destroy(editor)
      @editor_removed = true
      true
    else
      @errors << editor.errors.full_messages.to_sentence
      false
    end
  end

  def update_practice_partners(partners_params)
    changed = false

    incoming_partner_ids = partners_params.values.map { |attrs| attrs[:practice_partner_id].to_i }
    existing_partner_ids = @product.practice_partner_practices.pluck(:practice_partner_id)

    # Destroy associations not included in incoming data
    (existing_partner_ids - incoming_partner_ids).each do |partner_id|
      @product.practice_partner_practices.find_by(practice_partner_id: partner_id)&.destroy!
      changed = true
    end

    partners_params.each do |_, attributes|
      partner_id = attributes[:practice_partner_id].to_i
      if attributes[:_destroy] == '1'
        # Handle deletion if marked for destruction
        if existing_partner_ids.include?(partner_id)
          @product.practice_partner_practices.find_by(practice_partner_id: partner_id)&.destroy!
          changed = true
        end
      elsif existing_partner_ids.exclude?(partner_id) && partner_id != 0
        # Handle addition if not already associated
        @product.practice_partner_practices.create!(practice_partner_id: partner_id)
        changed = true
      end
    end

    changed
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => e
    @errors << e.message
    false
  end

  def collect_errors
    @errors.concat(@product.errors.full_messages)
  end

  def send_editor_invitation
    if ((Rails.env.production? && ENV['PROD_SERVERNAME'] == 'PROD') || Rails.env.test?)
      PracticeEditorMailer.invite_to_edit(@product, @added_editor.user).deliver
    end
  end
end
