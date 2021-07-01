ActiveAdmin.register Category do
  batch_action :destroy, false

  filter :name
  filter :description
  filter :related_terms

  index do
    id_column
    column :name
    column :short_name
    column :description
    column "Parent Category" do |p|
      if !p.nil?
        Category.find_by_id(p.parent_category_id)
       end
    end
    column :related_terms
    column :is_other
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :short_name
      row :description
      row "Parent Category" do |p|
        if !p.nil?
          parent_cat = Category.find_by_id(p.parent_category_id)
        end
      end
      row :related_terms
      row :is_other

      category_practice = CategoryPractice.where(category_id: params["id"])
      practices = []
      cat = Category.find_by_id(params["id"]).name
      category_practice.each do |cat_pract|
        practices << Practice.find_by_id(cat_pract.practice_id).name
      end
      practices_with_cat = ""
      practices.each do |practice|
        practices_with_cat += practice + ", "
      end
      if practices_with_cat.length > 0
        div do
          h3 'PRACTICES WITH ' + cat + ' CATEGORY: ' +  practices_with_cat[0..practices_with_cat.length - 3]
        end
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
              include_blank: false, collection: Category.get_parent_categories,
              input_html: { value: object[:parent_category_id] }, wrapper_html: { class: object.sub_categories.any? ? 'display-none' : '' }
        # ensures input is displayed as comma separated list
      f.input :related_terms_raw, label: 'Related Terms', hint: 'Comma separated list (e.g., COVID-19, Coronavirus)'
      f.input :is_other
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
          format.html { redirect_to admin_categories_path, notice: 'Category was successfully deleted.' }
        else
          format.html { redirect_to edit_admin_category_path(id: params[:id]), :flash => { :error => 'There was an error deleting your category.' }}
        end
      end
    end

    private

    def category_params
      params.require(:category).permit(:name, :short_name, :description, :parent_category_id, :is_other, related_terms:[])
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
