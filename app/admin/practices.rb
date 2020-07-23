include ActiveAdminHelpers

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
    column :enabled unless params[:scope] == "get_practice_owner_emails"
    column :created_at unless params[:scope] == "get_practice_owner_emails"
    actions do |practice|
      practice_enabled_action_str = practice.enabled ? "Disable" : "Enable"
      item practice_enabled_action_str, enable_practice_admin_practice_path(practice), method: :post
    end
  end

  member_action :enable_practice, method: :post do
    resource.enabled = !resource.enabled
    message = "\"#{resource.name}\" Practice enabled"
    unless resource.enabled
      message = "\"#{resource.name}\" Practice disabled"
    end
    resource.save
    redirect_back fallback_location: root_path, notice: message
  end

  member_action :export_practice_adoptions, method: :get do
    metrics_xlsx_file = Axlsx::Package.new do |p|
      # styling
      s = p.workbook.styles
      xlsx_main_header = s.add_style sz: 18, alignment: { horizontal: :center }, bg_color: '005EA2', fg_color: 'FFFFFF'
      xlsx_sub_header_3 = s.add_style sz: 14, alignment: { horizontal: :center }, bg_color: 'F3F3F3', fg_color: '000000', b: true, border: {style: :thin, color: '000000', edges: [:top, :bottom, :left, :right]}
      xlsx_entry = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center, wrap_text: true}
      xlsx_legend = s.add_style s2: 14, alignment: { horizontal: :center, vertical: :center, wrap_text: true}
      xlsx_divider = s.add_style sz: 12
      xlsx_legend_no_bottom_border = s.add_style b: true, u: true, border: {style: :thin, color: 'FFFFFF', edges: [:bottom]}
      xlsx_legend_no_top_border = s.add_style b: true, border: {style: :thin, color: 'FFFFFF', edges: [:top]}
      xlsx_legend_no_y_border = s.add_style b: true, border: {style: :thin, color: 'FFFFFF', edges: [:bottom, :top]}
      xlsx_bold = s.add_style fg_color: '000000'
      # building out xlsx file
      p.workbook.add_worksheet(:name => "Adoption Data - #{Date.today}") do |sheet|
        sheet.add_row ["#{@practice_name} Adoption Data - #{Date.today}"], style: xlsx_main_header
        sheet.add_row [''], style: xlsx_divider
        sheet.add_row ['Note: Adoption date is based on the adoption status.'], style: xlsx_legend_no_bottom_border
        sheet.add_row ['Completed/Unsuccessful: End Date'], style: xlsx_legend_no_y_border
        sheet.add_row ['In Progress: Start Date'], style: xlsx_legend_no_top_border
        sheet.merge_cells 'A1:C1'
        sheet.add_row [''], style: xlsx_divider
        @complete_map.each do |key, value|
          if value.present?
            sheet.add_row [
                              'State',
                              'Location',
                              'VISN',
                              'Station Number',
                              'Adoption Date',
                              'Adoption Status',
                              'Rurality',
                              'Facility Complexity'
                          ], style: xlsx_sub_header_3

            value.each do |v|
              sheet.add_row [
                                v[:state],
                                adoption_facility_name(v),
                                v[:visn],
                                v[:station_number],
                                adoption_date(v),
                                v[:status],
                                adoption_rurality(v),
                                v[:complexity]
                            ], style: xlsx_entry
            end
          else
            sheet.add_row ['No adoptions recorded for this practice.']
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
      f.input :name, label: 'Practice name'
      f.input :user, label: 'User email', as: :string, input_html: {name: 'user_email'}
      f.input :categories, as: :select, multiple: true, collection: Category.all.order(name: :asc).map { |cat| ["#{cat.name.capitalize}", cat.id]}, input_html: { value: @practice_categories }
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
      row(:name, label: 'Practice name')    { |practice| link_to(practice.name, practice_path(practice)) }
      row :slug
      row('Edit URL') { |practice| link_to(practice_overview_path(practice), practice_overview_path(practice)) }
      row(:user) {|practice| link_to(practice.user&.email, admin_user_path(practice.user)) if practice.user.present?}
      row :published
      row :approved
      row :enabled
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

  filter :nameYou
  filter :support_network_email

  controller do
    helper_method :adoption_facility_name
    helper_method :adoption_date
    helper_method :adoption_rurality
    helper_method :get_adoption_values
    before_action :set_categories_view, only: :edit
    before_action :set_practice_adoption_values, only: [:show, :export_practice_adoptions]
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

    def set_practice_adoption_values
      @facility_data = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
      @practice_name = resource.name
      @complete_map = {}
      get_adoption_values(resource, @complete_map)
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

