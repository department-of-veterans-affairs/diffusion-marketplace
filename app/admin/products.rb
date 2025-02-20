include UserUtils

ActiveAdmin.register Product do
  config.create_another = true
  actions :all

  # To do: set up index file export
  index do
    id_column
    column 'Product Name', :name
    column 'Owner Email', :user_email
    column 'Published', :published
    column 'Date Published', :date_published
    column 'Created At', :created_at
    column 'Last Updated', :updated_at
    actions do |product|
      product_retired_action_str = product.retired ? "Activate" : "Retire"
      item product_retired_action_str, retire_product_admin_product_path(product), method: :post
      product_published_action_str = product.published ? "Unpublish" : "Publish"
      item product_published_action_str, publish_product_admin_product_path(product), method: :post
    end
  end

  member_action :retire_product, method: :post do
    resource.toggle!(:retired)
    retired_state = resource.retired ? "retired" : "activated"
    message = "\"#{resource.name}\" was #{retired_state}"
    redirect_back fallback_location: root_path, notice: message
  end

  member_action :publish_product, method: :post do
    resource.toggle!(:published)
    published_state = resource.published ? "published" : "unpublished"
    message = "\"#{resource.name}\" was #{published_state}"
    redirect_back fallback_location: root_path, notice: message
  end

  filter :name
  filter :user_email, label: "Owner Email"
  filter :published

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names# shows errors on :base
    f.inputs  do
      f.input :name, label: 'Product name *Required*'
      f.input :user, label: 'User email', as: :string, input_html: {name: 'user_email', value: f.object.user&.email || ''}
    end
    f.actions
  end

  show do
    attributes_table  do
      row :id
      row(:name, label: 'Product name') { |product| link_to(product.name, product_path(product)) }
      row('Edit URL') { |product| link_to(product_description_path(product), product_description_path(product)) }
      row(:user) {|product| link_to(product.user&.email, admin_user_path(product.user)) if product.user.present?}
      row(:published, label: 'Published')
      row(:date_published, label: 'Date Published')
      row(:retired, label: 'Retired')
    end
  end

  controller do
    rescue_from ActiveRecord::RecordInvalid, with: :handle_error_redirect
    def scoped_collection
      super.left_joins(:user).includes(:user)
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create
      ActiveRecord::Base.transaction do
        @product = Product.new(product_params)
        handle_user_email(user_email_param)

        if @product.save
          add_user_as_editor
          handle_redirect_after_save(@product, "created")
        else
          flash[:error] = @product.errors.map(&:message).join(', ')
          redirect_to new_admin_product_path
        end
      end
    end

    def update
      ActiveRecord::Base.transaction do
        @product = Product.friendly.find(params[:id])
        @product.assign_attributes(product_params)
        handle_user_email(user_email_param)

        if @product.save
          add_user_as_editor
          handle_redirect_after_save(@product, "updated")
        else
          flash[:error] = @product.errors.map(&:message).join(', ')
          redirect_to edit_admin_product_path(@product)
        end
      end
    end

    private

    def handle_user_email(email)
      if email.present? && is_invalid_va_email(email)
        @product.errors.add(:user_email, 'must be a valid @va.gov address')
        raise ActiveRecord::RecordInvalid.new(@product)
      end
      set_product_user(email)
    end

    def handle_redirect_after_save(product, action)
      if params[:create_another] == "on"
        redirect_to new_admin_product_path, notice: "Product was successfully #{action}. You can create another one."
      else
        redirect_to admin_product_path(product), notice: "Product was successfully #{action}."
      end
    end

    def handle_error_redirect(exception)
      error_messages = exception.record.errors.map do |error|
        error.options[:message] || "Email #{error.type}"
      end
      path = action_name == 'update' ? edit_admin_product_path(@product) : new_admin_product_path
      redirect_to path, flash: { error: error_messages.join(', ') }
    end

    def set_product_user(email)
      if email.blank?
        @product.user = nil
        return
      end

      return if @product.user_email == email

      user = User.find_by(email: email)
      if user.nil?
        @product.errors.add(:user_email, 'does not match any registered users')
        raise ActiveRecord::RecordInvalid.new(@product)
      else
        @product.user = user
      end

      # Uncomment and update for Product when show page / commontator functionality enabled:
        # if the practice user is updated, remove the previous product user from the
        # commontator_thread subscribers list if the following conditions are also true
        # if previous_product_user.present? && previous_product_user != product.user &&
        #   product.commontator_thread.comments.where(creator_id: previous_product_user.id).empty?
        #     product.commontator_thread.unsubscribe(previous_product_user)
        # end
        # product.commontator_thread.subscribe(user)
    end

    def add_user_as_editor
      if @product.user.present? && !is_user_an_editor_for_innovation(@product, @product.user)
        PracticeEditor.create_and_invite(@product, @product.user)
      end
    end

    def product_params
      params.require(:product).permit(:name)
    end

    def user_email_param
      params[:user_email].presence
    end
  end
end
