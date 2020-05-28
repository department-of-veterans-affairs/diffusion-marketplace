ActiveAdmin.register Category do
  batch_action :destroy, false

  filter :name
  filter :description
  filter :related_terms

  index do
    id_column
    column :name
    column :description
    column :related_terms
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :related_terms
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, as: :string
      # ensures input is displayed as comma separated list
      f.input :related_terms_raw, label: 'Related Terms', hint: 'Comma separated list (e.g., COVID-19, Coronavirus)'
    end
    f.actions
  end

  controller do
    before_action :modify_related_terms_for_db, only: [:create, :update]

    def update
      category = Category.find(params[:id])
      updated = category.update_attributes(category_params)

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
          format.html { redirect_to admin_categories_path(notice: 'Category was successfully deleted.') }
        else
          format.html { redirect_to edit_admin_category_path(id: params[:id]), :flash => { :error => 'There was an error deleting your category.' }}
        end
      end
    end

    private

    def category_params
      params.require(:category).permit(:name, :description, related_terms:[])
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
  end
end
