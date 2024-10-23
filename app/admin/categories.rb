ActiveAdmin.register Category do
  menu label: "Tags"
  batch_action :destroy, false

  filter :name
  filter :description
  filter :related_terms

  config.clear_action_items!

  # Add a custom 'New Tag' button for the index page
  action_item :new_tag, only: :index do
    link_to 'New Tag', new_admin_category_path
  end

  action_item :edit, only: :show do
    link_to 'Edit Tag', edit_admin_category_path(resource) if authorized?(:edit, resource)
  end

  breadcrumb do
    if params[:action] == "show" || params[:action] == "edit"
      [
        link_to('Admin', admin_root_path),
        link_to('Tags', admin_categories_path)
      ]
    else
      [
        link_to('Admin', admin_root_path),
      ]
    end
  end

  index title: "Tags" do
    id_column
    column :name
    column :short_name
    column :description
    column "Parent Tag" do |p|
      if p.present?
        Category.find_by_id(p.parent_category_id)
       end
    end
    column :related_terms
    actions
  end

  show do
    attributes_table title: "Tag Details" do
      row :id
      row :name
      row :short_name
      row :description
      row "Parent Tag" do |p|
        if p.present?
          parent_cat = Category.find_by_id(p.parent_category_id)
        end
      end
      row :related_terms
      row "Innovations Tagged" do |c|
        c.innovable_practices
      end
      row "Products Tagged" do |c|
        c.innovable_products
      end
    end
  end

 form do |f|
    f.inputs do
      f.input :name
      f.input :short_name
      f.input :description, as: :string
      f.input :parent_category_id,
              as: :select, multiple: false,
              include_blank: false, collection: Category.get_parent_categories(true),
              input_html: { value: object[:parent_category_id] }, wrapper_html: { class: object.sub_categories.any? ? 'display-none' : '' },
              label: "Parent Tag"
        # ensures input is displayed as comma separated list
      f.input :related_terms_raw, label: 'Related Terms', hint: 'Comma separated list (e.g., COVID-19, Coronavirus)'
    end
    f.actions do
      f.action :submit, label: object.new_record? ? 'Create Tag' : 'Update Tag'
      f.cancel_link
    end
  end

  controller do
    before_action :modify_related_terms_for_db, only: [:create, :update]
    before_action :set_page_title, only: [:new, :edit, :show]

    def update
      category = Category.find(params[:id])
      updated = category.update(category_params)

      respond_to do |format|
        if updated
          format.html { redirect_to admin_category_path(id: params[:id]), notice: 'Category was successfully updated.' }
        else
          format.html { redirect_to edit_admin_category_path(id: params[:id]), :flash => { :error => 'There was an error updating your category.' }}
        end
      end
    end

    def destroy
      deleted = remove_category
      respond_to do |format|
        if deleted
          format.html { redirect_to admin_categories_path, notice: 'Category was successfully deleted.' }
        else
          format.html { redirect_to edit_admin_category_path(id: params[:id]), :flash => { :error => 'There was an error deleting your category.' }}
        end
      end
    end

    private

    def category_params
      params.require(:category).permit(:name, :short_name, :description, :parent_category_id, related_terms:[])
    end

    def modify_related_terms_for_db
      terms = params[:category][:related_terms_raw]
      if terms.present?
        params[:category][:related_terms] = terms.split(/\s*,\s*/)
      else
        params[:category][:related_terms] = []
      end
    end

    def remove_category
      begin
        CategoryPractice.where(category_id: params[:id]).map { |cp| cp.destroy! }
        Category.find(params[:id]).destroy!
        true
      rescue => e
        Rails.logger.error "remove_category error: #{e.message}"
        e
      end
    end

    def set_page_title
      case action_name
      when 'new'
        @page_title = 'New Tag'
      when 'edit'
        @page_title = "Edit Tag"
      end
    end
  end
end
