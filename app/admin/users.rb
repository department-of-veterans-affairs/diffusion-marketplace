# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :disabled, :skip_va_validation, role_ids: []
  actions :all, except: [:destroy]

  scope :enabled
  scope :disabled

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
      row :roles
      row :disabled
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :skip_va_validation
      f.input :password
      f.input :password_confirmation
      f.input :roles, as: :check_boxes
      f.input :disabled
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete 'password'
        params[:user].delete 'password_confirmation'
      end

      super
    end
  end
end
