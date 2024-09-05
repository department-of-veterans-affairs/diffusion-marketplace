include UserUtils

ActiveAdmin.register Product do
  config.create_another = true
  actions :all
  permit_params :id, :user_email, :create_another

  # To do: set up index file export
  index download_links: false do
    id_column
    column 'Product Name', :name
    column 'Owner email', :user_email
    column 'Created at', :created_at
    column 'Updated at', :updated_at
    actions
  end

  filter :name
  filter :user_email, label: "Owner Email"

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names# shows errors on :base
    f.inputs  do
      f.input :name, label: 'Product name *Required*'
      f.input :user, label: 'User email', as: :string, input_html: {name: 'user_email'}
    end
    f.actions
  end

  show do
    attributes_table  do
      row :id
      # row(:name, label: 'Product name') { |product| link_to(product.name, product_path(product)) } - uncomment when product show page is created
      # row('Edit URL') { |product| link_to(product_overview_path(product), product_overview_path(product)) } - uncomment when product editor is created
      row(:user) {|product| link_to(product.user&.email, admin_user_path(product.user)) if product.user.present?}
    end
  end

  controller do
    def scoped_collection
      super.joins(:user)
    end

    def create
      product = Product.new(product_params)
      handle_user_email(product)

      if product.save
        handle_redirect_after_save(product, "created")
      else
        handle_error_redirect(:new)
      end
    rescue => e
      handle_error_redirect(:new, e)
    end

    def update
      product = Product.find(params[:id])
      product.assign_attributes(product_params)
      handle_user_email(product)

      if product.save
        handle_redirect_after_save(product, "updated")
      else
        handle_error_redirect(:edit, product.id)
      end
    rescue => e
      handle_error_redirect(:edit, e, product.id)
    end

    private

    def handle_user_email(product)
      email = params[:user_email]
      raise StandardError.new 'There was an error. Email must be a valid @va.gov address.' if email.present? && is_invalid_va_email(email)
      set_product_user(product, email) if email.present?
    end

    def handle_redirect_after_save(product, action)
      if params[:create_another] == "on"
        redirect_to new_admin_product_path, notice: "Product was successfully #{action}. You can create another one."
      else
        redirect_to admin_product_path(product), notice: "Product was successfully #{action}."
      end
    end

    def handle_error_redirect(action, error = nil, product_id = nil)
      path = action == :new ? new_admin_product_path : edit_admin_product_path(product_id)
      redirect_to path, flash: { error: error&.message }
    end

    def set_product_user(product, email)
      return if email.blank? || product.user&.email == email

      # create new user if needed
      user = User.find_or_initialize_by(email: email)
      skip_validations_and_save_user(user) if user.new_record?
      product.user = user

      # un-comment and update for Product once the editor workflow is created:
        # if product.user.present? && !is_user_an_editor_for_innovation(product, product.user)
        #   ProductEditor.create_and_invite(product, product.user)
        # end

      # Uncomment and update for Product when show page / commontator functionality enabled:
        # if the practice user is updated, remove the previous product user from the
        # commontator_thread subscribers list if the following conditions are also true
        # if previous_product_user.present? && previous_product_user != product.user &&
        #   product.commontator_thread.comments.where(creator_id: previous_product_user.id).empty?
        #     product.commontator_thread.unsubscribe(previous_product_user)
        # end
        # product.commontator_thread.subscribe(user)
    end

    def product_params
      params.require(:product).permit(:name)
    end
  end
end