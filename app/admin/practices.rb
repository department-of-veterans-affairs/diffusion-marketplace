ActiveAdmin.register Practice do
  actions :all, except: [:destroy]
  permit_params :name, :user_email
  config.create_another = true

  scope :published
  scope :unpublished
  scope :get_practice_owner_emails
  csv do
    if params[:scope] == "get_practice_owner_emails"
      column(:practice_name) {|practice| practice.name}
      column(:owner_email) {|practice| practice.user&.email}
    else
      Practice.column_names.each do |item|
        column(item)
      end
    end
  end

  index do
    Practice.create
    selectable_column unless params[:scope] == "get_practice_owner_emails"
    id_column unless params[:scope] == "get_practice_owner_emails"
    column(:practice_name) {|practice| practice.name}
    column :support_network_email unless params[:scope] == "get_practice_owner_emails"
    column(:owner_email) {|practice| practice.user&.email}
    column :created_at unless params[:scope] == "get_practice_owner_emails"
    actions
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys# shows errors on :base
    f.inputs  do
      f.input :name, label: 'Practice name'
      f.input :user, label: 'User email', as: :string, input_html: {name: 'user_email'}
      f.input :categories, as: :select, multiple: true, collection: Category.all.order(name: :asc).map { |cat| ["#{cat.name.capitalize}", cat.id]}, input_html: { value: @practice_categories }
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
    before_action :set_categories_view, only: :edit
    after_action :update_categories, only: [:create, :update]

    before_create do |practice|
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

    def set_categories_view
      @practice_categories = []
      current_categories = CategoryPractice.where(practice_id: params[:id])
      unless current_categories.empty?
        current_categories.map do |cp|
          @practice_categories.push(cp[:category_id])
        end
      end
    end

    def update_categories
      # remove the first category id--first is always empty ''
      selected_categories = params[:practice][:category_ids].drop(1)
      selected_categories.map! { |cat| cat.to_i }
      practice = Practice.find_by(name: params[:practice][:name])
      current_categories = CategoryPractice.where(practice_id: practice[:id])
      if selected_categories.length > 0
        selected_categories.map { |cat| CategoryPractice.find_or_create_by!(category_id: cat, practice_id: practice[:id]) }
      end

      if params[:action] == 'update' && current_categories.present?
        if selected_categories.empty?
          current_categories.map { |cat| cat.destroy! }
        else
          current_categories.map { |cat| cat.destroy! unless selected_categories.include? cat.category_id }
        end
      end
    end
  end
end

