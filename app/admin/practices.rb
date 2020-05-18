ActiveAdmin.register Practice do
  actions :all, except: [:destroy]
  permit_params :name, :user_email
  config.create_another = true

  scope :published
  scope :unpublished

  index do
    selectable_column
    id_column
    column :name
    column :support_network_email
    column(:user) {|practice| practice.user&.email}
    column :created_at
    actions
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys# shows errors on :base
    f.inputs  do
      f.input :name, label: 'Practice name'
      f.input :user, label: 'User email', as: :string, input_html: {name: 'user_email'}
    end        # builds an input field for every attribute
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    attributes_table  do
      row :id
      row(:name, label: 'Practice name')    { |practice| link_to(practice.name, practice_path(practice)) }
      row :slug
      row('Edit URL') { |practice| link_to(practice_overview_path(practice), practice_overview_path(practice)) }
      row(:user) {|practice| link_to(practice.user&.email, admin_user_path(practice.user)) if practice.user.present?}
      row :published
      row :approved
    end
    h3 'Versions'
    table_for practice.versions.order(created_at: :desc) do |version|
      column :event
      column :whodunnit
      column :created_at
      column do |v| link_to 'View', admin_version_path(v.id) end
      column do |v| link_to('Revert', revert_admin_version_path(v.id), method: :put, data: {confirm: 'Are you sure you want to do this? This will override the practice with the specified version.'}) end
    end
  end

  filter :nameYou
  filter :support_network_email

  controller do
    include StoreRequestConcern
    before_create do |practice|
      store_request_in_thread
      if params[:user_email].present?
        set_practice_user(practice)
      end
      practice.approved = true
    end

    before_update do |practice|
      set_practice_user(practice) if params[:user_email].present?
      practice.user = nil unless params[:user_email].present?
    end

    def set_practice_user(practice)
      email = params[:user_email].downcase
      user = User.find_by(email: email)

      # create a new user if they do not exist
      user = User.new(email: email) if user.blank?

      # set the user's attributes based on ldap entry
      user.skip_password_validation = true
      user.skip_va_validation = true
      # TODO: public site: do we want created users to confirm their accounts?
      user.confirm unless ENV['USE_NTLM'] == 'true'
      user.save
      practice.user = user
      practice.commontator_thread.subscribe(user)
    end


    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end

