ActiveAdmin.register Practice do
  actions :all, except: [:new, :create, :destroy]

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

  show do
    attributes_table  do
      row :id
      row(:name)    { |practice| link_to(practice.name, practice_path(practice)) }
      row :slug
      row :short_name
      row :description
      row :position
      row :cboc
      row :program_office
      row :initiating_facility
      row :vha_visn
      row :medical_center
      row :number_adopted
      row :number_failed
      row :business_case_summary
      row :support_network_email
      row :va_pulse_link
      row :additional_notes
      row :date_initiated
      row :impact_veteran_experience
      row :impact_veteran_satisfaction
      row :impact_other_veteran_experience
      row :impact_financial_estimate_saved
      row :impact_financial_per_veteran
      row :impact_financial_roi
      row :impact_financial_other
      row :phase_gate
      row :successful_implementation
      row :target_measures
      row :target_success
      row :implementation_time_estimate
      row :implementation_time_estimate_description
      row :implentation_summary
      row :implementation_fte
      row :tagline
      row :gold_status_tagline
      row :summary
      row :risk_level_aggregate
      row :cost_savings_aggregate
      row :cost_to_implement_aggregate
      row :veteran_satisfaction_aggregate
      row :difficulty_aggregate
      row :sustainability_aggregate
      row :origin_title
      row :origin_story
      row :need_additional_staff
      row :need_training
      row :need_policy_change
      row :need_new_license
      row :training_test
      row :training_test_details
      row :training_provider
      row :required_training_summary
      row :training_length
      row :facility_complexity_level
      row :main_display_image_original_w
      row :main_display_image_original_h
      row :main_display_image_crop_x
      row :main_display_image_crop_y
      row :main_display_image_crop_w
      row :main_display_image_crop_h
      row :origin_picture_original_w
      row :origin_picture_original_h
      row :origin_picture_crop_x
      row :origin_picture_crop_y
      row :origin_picture_crop_w
      row :origin_picture_crop_h
      row :number_departments
      row :it_required
      row :process
      row :created_at
      row :updated_at
      row :main_display_image_file_name
      row :main_display_image_content_type
      row :main_display_image_file_size
      row :main_display_image_updated_at
      row :origin_picture_file_name
      row :origin_picture_content_type
      row :origin_picture_file_size
      row :origin_picture_updated_at
      row :user_id
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
    def edit
      redirect_to edit_practice_path(resource)
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end

