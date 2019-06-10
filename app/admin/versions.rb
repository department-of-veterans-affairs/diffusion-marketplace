ActiveAdmin.register Version do
  actions :index, :show, :revert
  index do
    selectable_column
    id_column
    column :item_type
    column :item_id
    column :event
    column :whodunnit
    column :created_at
    actions
  end

  show do
    if resource.item.present?
      panel "View #{resource.item_type}" do
        if resource.item_type == 'Practice'
          link_to "View #{resource.item.name}", admin_practice_path(resource.item)
        else
        end
      end
    end
    attributes_table do
      row :item_type
      row :item_id
      row :event
      row :whodunnit
      row :created_at
      row :object_changes
    end
    active_admin_comments
  end

  member_action :revert, method: :put do
    resource.reify.save!
  end

  action_item :revert, only: :show do
    link_to 'Revert to this version', revert_admin_version_path(resource.id), method: :put, data: {confirm: "Are you sure you want to do this? This will override the #{resource.item_type} with the specified version."}
  end

  controller do
    def find_resource
      PaperTrail::Version.find(params[:id])
    end
  end
end
