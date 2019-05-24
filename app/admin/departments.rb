ActiveAdmin.register Department do
  permit_params :position, :name, :short_name, :description, :id

  filter :name
  filter :description

  index do
    selectable_column
    id_column
    column :position
    column :short_name
    column :name
    column :description
    actions
  end
end
