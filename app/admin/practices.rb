include ActiveAdminHelpers
include PracticeEditorUtils
include UserUtils

ActiveAdmin.register Practice do
  actions :all, except: [:destroy]
  permit_params :name, :user_email, :retired, :retired_reason
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

    # ensure lowercase practice names are ordered correctly
    order_by(:name) do |order_clause|
      ['lower(practices.name)', order_clause.order].join(' ')
    end

  order_by(:date_published) do |order_clause|
    if order_clause.order == 'desc'
      [order_clause.to_sql, 'NULLS LAST'].join(' ')
    else
      [order_clause.to_sql, 'NULLS FIRST'].join(' ')
    end
  end

  index do
    selectable_column unless params[:scope] == "get_practice_owner_emails"
    id_column unless params[:scope] == "get_practice_owner_emails"
    column 'Practice Name', :name
    column :support_network_email unless params[:scope] == "get_practice_owner_emails"
    column(:owner_email) {|practice| practice.user&.email}
    column 'Public', :is_public
    column :created_at unless params[:scope] == "get_practice_owner_emails"
    column 'Last Updated', :updated_at unless params[:scope] == "get_practice_owner_emails"
    column :date_published unless params[:scope] == "get_practice_owner_emails"
    column :enabled unless params[:scope] == "get_practice_owner_emails"
    column :hidden unless params[:scope] == "get_practice_owner_emails"
    column :highlight unless params[:scope] == "get_practice_owner_emails"
    column :retired unless params[:scope] == "get_practice_owner_emails"

    actions do |practice|
      practice_enabled_action_str = practice.enabled ? "Disable" : "Enable"
      item practice_enabled_action_str, enable_practice_admin_practice_path(practice), method: :post
      practice_hidden_action_str = practice.hidden ? "Show" : "Hide"
      item practice_hidden_action_str, hide_practice_admin_practice_path(practice), method: :post
      practice_retired_action_str = practice.retired ? "Activate" : "Retire"
      item practice_retired_action_str, retire_practice_admin_practice_path(practice), method: :post
      practice_highlight_action_str = practice.highlight ? "Unhighlight" : "Highlight"
      item practice_highlight_action_str, highlight_practice_admin_practice_path(practice), method: :post
      practice_highlight_action_str = practice.is_public ? "Make Private" : "Make Public"
      item practice_highlight_action_str, set_practice_privacy_admin_practice_path(practice), class: 'toggle-practice-privacy-link', method: :post
    end
  end

  member_action :retire_practice, method: :post do
    resource.retired = !resource.retired
    message = "\"#{resource.name}\" was retired"
    unless resource.retired
      message = "\"#{resource.name}\" was activated"
      resource.retired_reason = nil if resource.retired == false
    end
    resource.save
    redirect_back fallback_location: root_path, notice: message
  end

  member_action :enable_practice, method: :post do
    resource.enabled = !resource.enabled
    update_boolean_attr(resource.enabled, 'Practice enabled', 'Practice disabled')
  end

  member_action :highlight_practice, method: :post do
    to_highlight = !resource.highlight

    highlighted_pr_count = Practice.where(highlight: true, published: true, enabled: true, approved: true).size
    if to_highlight && !resource.published
      message = "Practice must be published to be highlighted."
      redirect_back fallback_location: root_path, :flash => { :error => message }
    elsif to_highlight && highlighted_pr_count >= 1
      message = "Only one practice can be highlighted at a time."
      redirect_back fallback_location: root_path, :flash => { :error => message }
    else
      resource.highlight = to_highlight
      resource.highlight_title = nil
      resource.highlight_body = nil
      message = "\"#{resource.name}\" Practice highlighted"
      unless resource.highlight
        message = "\"#{resource.name}\" Practice unhighlighted"
      end
      resource.save
      redirect_back fallback_location: root_path, notice: message
    end
  end

  member_action :hide_practice, method: :post do
    resource.hidden = !resource.hidden
    message = "\"#{resource.name}\" is hidden from search"
    unless resource.hidden
      message = "\"#{resource.name}\" is no longer hidden from search"
    end
    resource.save
    redirect_back fallback_location: root_path, notice: message
  end

  member_action :set_practice_privacy, method: :post do
    resource.is_public = !resource.is_public
    update_boolean_attr(resource.is_public, 'is now a public-facing practice', 'is now a VAEC internal-facing practice')
  end

  member_action :export_practice_adoptions, method: :get do
    metrics_xlsx_file = Axlsx::Package.new do |p|
      # styling
      adoption_xlsx_styles(p)

      # building out xlsx file
      p.workbook.add_worksheet(:name => "Adoption Data - #{Date.today}") do |sheet|
        sheet.add_row ["#{@practice_name} Adoption Data - #{Date.today}"], style: @xlsx_main_header
        sheet.add_row [''], style: @xlsx_divider
        sheet.add_row ['Please Note'], style: @xlsx_legend_no_bottom_border
        sheet.add_row ['Adoption date is based on the adoption status.'], style: @xlsx_legend_no_y_border
        sheet.add_row [''], style: @xlsx_divider
        sheet.add_row ['Successful/Unsuccessful: End Date'], style: @xlsx_legend_no_y_border
        sheet.add_row ['In Progress: Start Date'], style: @xlsx_legend_no_top_border
        sheet.merge_cells 'A1:C1'
        sheet.add_row [''], style: @xlsx_divider

        @complete_map.each do |name, value|
          if value.present?
            # adoption counts
            sheet.add_row ['Adoption Counts'], style: @xlsx_sub_header

            sheet.add_row ["#{@date_headers[:current]}", @adoption_counts[:adopted_this_month]], style: @xlsx_entry
            sheet.add_row ["#{@date_headers[:one_month_ago]}", @adoption_counts[:adopted_one_month_ago]], style: @xlsx_entry
            sheet.add_row ["#{@date_headers[:two_month_ago]}", @adoption_counts[:adopted_two_months_ago]], style: @xlsx_entry
            sheet.add_row ["#{@date_headers[:total]}", @adoption_counts[:total_adopted]], style: @xlsx_entry

            sheet.add_row [''], style: @xlsx_divider

            # adoption information
            sheet.add_row ['Adoption Information'], style: @xlsx_sub_header
            sheet.add_row [
                'State',
                'Location',
                'VISN',
                'Station Number',
                'Adoption Date',
                'Adoption Status',
                'Rurality',
                'Facility Complexity'
            ], style: @xlsx_sub_header_3

            value.each do |v|
              sheet.add_row [
                  v[:state],
                  adoption_facility_name(v),
                  v[:visn],
                  v[:station_number],
                  adoption_date(v),
                  adoption_status(v),
                  adoption_rurality(v),
                  v[:complexity]
              ], style: @xlsx_entry
            end
          end
        end
      end
      p.use_shared_strings = true
    end

    # generating downloadable .xlsx file
    send_data metrics_xlsx_file.to_stream.read, :filename => "adoptions_#{Date.today}.xlsx", :type => "application/xlsx"
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys# shows errors on :base
    f.inputs  do
      f.input :name, label: 'Innovation name'
      f.input :user, label: 'User email', as: :string, input_html: {name: 'user_email'}
      f.input :categories, as: :select, multiple: true, collection: Category.all.order(name: :asc).map { |cat| ["#{cat.name.capitalize}", cat.id]}, input_html: { value: @practice_categories }
      if object.highlight
        f.input :highlight_title, label: 'Highlighted Innovation Title'
        f.input :highlight_body, label: 'Highlighted Innovation Body'
      end
      f.input :retired, label: 'Innovation retired?'
      f.input :retired_reason, label: 'Retired reason', as: :quill_editor
    end        # builds an input field for every attribute
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    # export .xlsx button
    if resource.diffusion_histories.present?
      form action: export_practice_adoptions_admin_practice_path, method: :get, style: 'text-align: left' do |f|
        f.input :submit, type: :submit, value: 'Download Adoption Data', style: 'margin-bottom: 1rem'
      end
    end

    attributes_table  do
      row :id
      row(:name, label: 'Innovation name')    { |practice| link_to(practice.name, practice_path(practice)) }
      row :slug
      row('Edit URL') { |practice| link_to(practice_overview_path(practice), practice_overview_path(practice)) }
      row(:user) {|practice| link_to(practice.user&.email, admin_user_path(practice.user)) if practice.user.present?}
      row :published
      row :approved
      row :enabled
      row('Public') { |p| status_tag p.is_public? }
      row :highlight
      if practice.highlight
        row :highlight_title
        row :highlight_body
      end
      row :retired
      row :retired_reason
    end
    h3 'Versions'
    table_for practice.versions.order(created_at: :desc) do |version|
      column :event
      column :whodunnit
      column :created_at
      column do |v| link_to 'View', admin_version_path(v.id) end
      column do |v| link_to('Revert', revert_admin_version_path(v.id), method: :put, data: {confirm: 'Are you sure you want to do this? This will override the practice with the specified version.'}) end
    end
    active_admin_comments
  end

  filter :name
  filter :support_network_email
  filter :owner_email

  controller do
    helper_method :adoption_facility_name
    helper_method :adoption_date
    helper_method :adoption_rurality
    helper_method :adoption_status
    helper_method :get_adoption_values
    helper_method :adoption_counts_by_practice
    helper_method :adoption_xlsx_styles
    before_action :set_categories_view, only: :edit
    before_action :set_practice_adoption_values, only: [:show, :export_practice_adoptions]
    after_action :update_categories, only: [:create, :update]
    after_action :update_highlight_attr, only: [:update]

    def create_or_update_practice
      begin
        practice_name = params[:practice][:name]
        blank_practice_name = params[:practice][:name].blank?
        practice_slug = params[:id]
        email = params[:user_email]
        #highlight_body = params[:practice][:highlight_body]
        retired = params[:practice][:retired] == "1" ? true : false
        retired_reason = retired ? params[:practice][:retired_reason] : nil
        # raise an error if practice name is left blank
        raise StandardError.new 'There was an error. Innovation name cannot be blank.' if blank_practice_name

        practice = Practice.find_by(slug: practice_slug)

        practice_by_name = Practice.find_by(name: practice_name)
        # raise an error if there's already a practice with a name that matches the user's input for the name field
        raise StandardError.new 'There was an error. Innovation name already exists.' if practice_by_name.present? && practice_by_name != practice
        practice ||= Practice.create(name: practice_name)
        #practice.highlight_body = highlight_body
        practice.retired = retired
        practice.retired_reason = retired_reason

        # raise an error if practice email does not meet validation requirements
        blank_email = email.blank?

        if blank_email
          raise StandardError.new 'There was an error. Email cannot be blank.'
        elsif is_invalid_va_email(email)
          raise StandardError.new 'There was an error. Email must be a valid @va.gov address.'
        end

        set_practice_user(practice) if email.present?
        practice.user = nil unless email.present?
        if practice.user.present? && !is_user_an_editor_for_practice(practice, practice.user)
          PracticeEditor.create_and_invite(practice, practice.user)
        end
        respond_to do |format|
          format.html { redirect_to admin_practice_path(practice), notice: "Innovation was successfully updated." }
        end
      rescue => e
        respond_to do |format|
          if params[:action] === 'update'
            format.html { redirect_to edit_admin_practice_path(Practice.find_by(slug: practice_slug)), flash: { error:  "#{e.message}"} }
          else
            format.html { redirect_to new_admin_practice_path, flash: { error:  "#{e.message}"} }
          end
        end
      end
    end

    def create
      create_or_update_practice
    end

    def update
      create_or_update_practice
    end

    def set_practice_adoption_values
      @facility_data = VaFacility.cached_va_facilities
      @practice_name = resource.name
      @complete_map = {}
      @adoption_counts = {}
      get_adoption_values(resource, @complete_map)
      @adoption_counts = adoption_counts_by_practice(resource)
    end

    def set_practice_user(practice)
      previous_practice_user = practice.user
      email = params[:user_email].downcase
      name = params[:practice][:name]
      user = User.find_by(email: email)

      # create a new user if they do not exist
      user = User.new(email: email) if user.blank?
      skip_validations_and_save_user(user)

      practice.user = user
      # if the practice user is updated, remove the previous practice user from the commontator_thread subscribers list if the following conditions are also true
      if previous_practice_user.present? && previous_practice_user != practice.user && practice.commontator_thread.comments.where(creator_id: previous_practice_user.id).empty?
        practice.commontator_thread.unsubscribe(previous_practice_user)
      end
      practice.commontator_thread.subscribe(user)
      practice.approved = true
      practice.name = name
      practice.save
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
      current_categories = CategoryPractice.where(practice_id: practice[:id]) unless practice.nil?
      if selected_categories.length > 0 && practice.present?
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

    def update_highlight_attr
      practice_slug = params[:id]
      practice = Practice.find_by(slug: practice_slug)
      practice.update(highlight_title: params[:practice][:highlight_title], highlight_body: params[:practice][:highlight_body])
    end

    def update_boolean_attr(attr, message_1, message_2)
      message = "\"#{resource.name}\" #{message_1}"

      unless attr
        message = "\"#{resource.name}\" #{message_2}"
      end

      resource.save
      redirect_back fallback_location: root_path, notice: message
    end
  end
end
