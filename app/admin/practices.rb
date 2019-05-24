ActiveAdmin.register Practice do
  actions :all, except: [:update, :destroy]

  scope :published
  scope :unpublished

  index do
    selectable_column
    id_column
    column :name
    column :support_network_email
    column :created_at
    actions
  end

  filter :name
  filter :support_network_email

  controller do
    def edit
      redirect_to edit_practice_path(resource)
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
