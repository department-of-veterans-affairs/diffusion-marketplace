ActiveAdmin.register VisnLiaison do
  batch_action :destroy, false

  filter :first_name
  filter :last_name
  filter :email
  filter :description
  filter :related_terms

  index do
    id_column
    column :first_name
    column :last_name
    column :email
    column :primary
    column('VISN number', sortable: :visn_id) { |visn_liaison| visn_liaison.visn[:number] }

    actions do |visn_liaison|
      visn_liaison_is_primary = visn_liaison[:primary] ? "Make Secondary" : "Make Primary"
      link_to visn_liaison_is_primary, set_primary_admin_visn_liaison_path(visn_liaison), method: :post
    end
  end

  member_action :set_primary, method: :post do
    resource.primary = !resource.primary
    can_save = set_can_save(resource)
    message = set_primary_error_msg(resource)
    resource.save if can_save
    if can_save
      redirect_back fallback_location: root_path, notice: message
    else
      redirect_back fallback_location: root_path, flash: { error: message }
    end
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :primary
      row('VISN number') { |visn_liaison| visn_liaison.visn[:number] }
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :primary
      f.input :visn, as: :select, multiple: false, collection: Visn.all.order(number: :asc).map {|visn| ["VISN #{visn.number} - #{visn.name}", visn.id]}, input_html: { value: object[:visn_id] }
    end
    f.actions
  end

  controller do
    def update
      create_or_update_visn_liaison(params)
    end

    def create
      create_or_update_visn_liaison(params)
    end

    def create_or_update_visn_liaison(params)
      is_update = params[:_method] === 'patch'
      vl_id = params[:id] if is_update
      visn_liaison_params = set_visn_liaison_params(params)
      visn_liaison_params_with_id = is_update ? visn_liaison_params.merge({id: vl_id}) : visn_liaison_params
      can_save = set_can_save(visn_liaison_params_with_id)
      message = can_save ? "VISN liaison was successfully #{is_update ? 'updated' : 'created'}." : "There was an error #{is_update ? 'updating' : 'creating'} your VISN liaison: #{set_primary_error_msg(visn_liaison_params_with_id)}"

      if is_update
        saved_resource = resource.update_attributes(visn_liaison_params) if can_save
      else
        saved_resource = VisnLiaison.create!(visn_liaison_params) if can_save
      end

      respond_to do |format|
        if saved_resource
          if is_update
            format.html { redirect_to admin_visn_liaison_path(id: vl_id), notice: message }
          else
            format.html { redirect_to new_admin_visn_liaison_path,  notice: message }
          end
        else
          if is_update
            format.html { redirect_to edit_admin_visn_liaison_path(id: vl_id), flash: { error: message }}
          else
            format.html { redirect_to new_admin_visn_liaison_path, flash: { error: message }}
          end
        end
      end
    end

    private

    def set_visn_liaison_params(params)
      vl = params[:visn_liaison]
      return { first_name: vl[:first_name] || '', last_name: vl[:last_name] || '', email: vl[:email] || '', visn_id: vl[:visn_id].to_i, primary: vl[:primary] === '1' }
    end

    def visn_liaison_ct(visn_liaison)
      query = VisnLiaison.where(visn_id: visn_liaison[:visn_id], primary: true)
      query.where.not(id: visn_liaison[:id]) if visn_liaison[:id].present?
      return query.size
    end

    def set_can_save(visn_liaison)
      can_save = true
      if visn_liaison[:primary]
        can_save = visn_liaison_ct(visn_liaison) === 0
      end
      return can_save
    end

    def set_primary_error_msg(visn_liaison)
      visn = Visn.find(visn_liaison[:visn_id])
      visn_name = "VISN #{visn[:number]} - #{visn[:name]}"
      message = "VISN liaison, #{visn_liaison[:first_name]} #{visn_liaison[:last_name]}, has been made a secondary contact of #{visn_name}."
      if visn_liaison[:primary]
        if visn_liaison_ct(visn_liaison) === 0
          message = "VISN liaison, #{visn_liaison[:first_name]} #{visn_liaison[:last_name]}, has been made a primary contact of #{visn_name}."
        else
          message = "There can be only one primary contact for #{visn_name}."
        end
      end
      return message
    end
  end
end
