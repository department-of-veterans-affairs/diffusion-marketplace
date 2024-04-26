ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :disabled, :skip_va_validation, role_ids: []
  actions :all, except: [:destroy]

  scope :enabled
  scope :disabled
  scope :admins

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email

  show do
    attributes_table do
      row :email
      row :last_sign_in_at
      row :first_name
      row :last_name
      row :job_title
      row :phone_number
      row :visn
      row :created_at
      row :confirmed_at
      row "Admin" do |user|
        user.has_role?(:admin)
      end
      row "PageGroup Editor Roles" do |user|
        page_group_roles = user.roles.where(name: 'page_group_editor').map(&:resource_id).join(', ')
        page_group_roles.present? ? page_group_roles : nil
      end
      row :disabled
    end
    active_admin_comments
    h3 'Versions'
    table_for user.versions.order(created_at: :desc) do |version|
      column :event
      column :whodunnit
      column :created_at
     end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :skip_va_validation
      f.input :password
      f.input :password_confirmation
      # instance-scoped editor roles should be left out of the collection as they are handled in the
      # given instance's edit form:
      f.input :roles, as: :check_boxes, collection: Role.where(name: ['admin'])
      f.input :disabled
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete "password"
        params[:user].delete "password_confirmation"
      end

      super
    end
  end
end
