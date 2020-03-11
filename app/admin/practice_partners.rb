ActiveAdmin.register PracticePartner do
  permit_params :position, :name, :short_name, :description, :id, :color, :icon, practice_ids: []

  filter :name
  filter :description

  index do
    selectable_column
    id_column
    column :position
    column :short_name
    column :name
    column :slug
    actions
  end

  show do
    attributes_table do
      row :name
      row :short_name
      row :description
      row :position
      row :color
      row :icon
      row :created_at
      row :updated_at
      row :slug
      row :practices
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :short_name
      f.input :description
      f.input :position
      f.input :color
      f.input :icon
      f.input :slug
      f.input :practices, as: :select
    end
    f.actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
