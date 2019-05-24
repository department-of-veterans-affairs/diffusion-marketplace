ActiveAdmin.register PracticePartner do
  permit_params :position, :name, :short_name, :description, :id, :color, :icon

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

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
