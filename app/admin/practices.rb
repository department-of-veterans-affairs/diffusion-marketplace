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
      column :id
      column :name
      column :short_name
      column :description
      column :position
      column :cboc
      column :program_office
      column :initiating_facility
      column :vha_visn
      column :medical_center
      column :number_adopted
      column :number_failed
      column :business_case_summary
      column :support_network_email
      column :va_pulse_link
      column :additional_notes
      column :date_initiated
      column :impact_veteran_experience
      column :impact_veteran_satisfaction
      column :impact_other_veteran_experience
      column :impact_financial_estimate_saved
      column :impact_financial_per_veteran
      column :impact_financial_roi
      column :impact_financial_other
      column :phase_gate
      column :successful_implementation
      column :target_measures
      column :target_success
      column :implementation_time_estimate
      column :implementation_time_estimate_description
      column :implentation_summary
      column :implementation_fte
      column :tagline
      column :gold_status_tagline
      column :summary
      column :risk_level_aggregate
      column :cost_savings_aggregate
      column :cost_to_implement_aggregate
      column :veteran_satisfaction_aggregate
      column :difficulty_aggregate
      column :sustainability_aggregate
      column :origin_title
      column :origin_story
      column :need_additional_staff
      column :need_training
      column :need_policy_change
      column :need_new_license
      column :training_test
      column :training_test_details
      column :training_provider
      column :required_training_summary
      column :training_length
      column :facility_complexity_level
      column :main_display_image_original_w
      column :main_display_image_original_h
      column :main_display_image_crop_x
      column :main_display_image_crop_y
      column :main_display_image_crop_w
      column :main_display_image_crop_h
      column :origin_picture_original_w
      column :origin_picture_original_h
      column :origin_picture_crop_x
      column :origin_picture_crop_y
      column :origin_picture_crop_w
      column :origin_picture_crop_h
      column :number_departments
      column :it_required
      column :process
      column :created_at
      column :updated_at
      column :main_display_image_file_name
      column :main_display_image_content_type
      column :main_display_image_file_size
      column :main_display_image_updated_at
      column :origin_picture_file_name
      column :origin_picture_content_type
      column :origin_picture_file_size
      column :origin_picture_updated_at
      column :user_id
      column :published
      column :approved
      column :slug
      column :highlight
      column :featured
      column :ahoy_visit_id
      column :training_provider_role
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
  end
end

