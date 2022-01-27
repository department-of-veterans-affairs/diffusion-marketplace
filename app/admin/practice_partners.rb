include ActiveAdminUtils

ActiveAdmin.register PracticePartner do
  permit_params :position, :name, :short_name, :description, :id, :color, :icon, :is_major, practice_ids: []

  filter :name
  filter :description

  index do
    selectable_column
    id_column
    column :position
    column :short_name
    column :name
    column :slug
    column :is_major
    actions do |practice_partner|
      practice_partner_is_major_action_str = practice_partner.is_major ? "Make minor" : "Make major"
      item practice_partner_is_major_action_str, set_practice_partner_importance_admin_practice_partner_path(practice_partner), method: :post
    end
  end

  show do
    attributes_table do
      row :name
      row :short_name
      row :description
      row :position
      row :color
      row :icon
      row :created_at
      row :updated_at
      row :slug
      row('Practices') do |partner|
        partner.practices.order(Arel.sql("lower(name) ASC"))
      end
      row('Major Practice Partner') { |partner| status_tag partner.is_major? }
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name, label: 'Name *Required*'
      f.input :short_name
      f.input :description
      f.input :position
      f.input :color
      f.input :icon
      f.input :slug
      f.input :practices, as: :select, multiple: true, collection: Practice.published.order(Arel.sql("lower(name) ASC")).map { |p| ["#{p.name.capitalize}", p.id]}
      f.input :is_major, label: 'Major practice partner?'
    end
    f.actions
  end

  member_action :set_practice_partner_importance, method: :post do
    resource.is_major = !resource.is_major
    update_boolean_attr(resource.is_major, 'is now a major practice partner.', 'is now a minor practice partner.')
  end

  controller do
    before_action :set_selected_practices, only: :edit
    after_action :update_partner_practices, only: [:create, :update]

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create_or_update_practice_partner
      begin
        practice_partner_params = params[:practice_partner]
        name = practice_partner_params[:name]
        short_name = practice_partner_params[:short_name]
        description = practice_partner_params[:description]
        position = practice_partner_params[:position]
        color = practice_partner_params[:color]
        icon = practice_partner_params[:icon]
        slug = practice_partner_params[:slug]
        blank_practice_partner_name = practice_partner_params[:name].blank?
        is_major = practice_partner_params[:is_major] === '1' ? true : false
        # raise an error if practice partner name is left blank
        raise StandardError.new 'There was an error. Practice partner name cannot be blank.' if blank_practice_partner_name

        practice_partner = PracticePartner.find_by(slug: slug)

        # raise an error if there's already a practice partner with a slug that matches the parameterized version of the inputted name
        raise StandardError.new "There was an error. A practice partner with the slug: #{name.parameterize} already exists." if PracticePartner.find_by(slug: name.parameterize) && practice_partner.nil?

        practice_partner ||= PracticePartner.new(name: name)
        practice_partner.name = name
        practice_partner.short_name = short_name
        practice_partner.description = description
        practice_partner.position = position
        practice_partner.color = color
        practice_partner.icon = icon
        practice_partner.is_major = is_major

        practice_partner.save

        respond_to do |format|
          format.html { redirect_to admin_practice_partner_path(practice_partner), notice: "Practice partner was successfully #{params[:action] === 'create' ? 'created' : 'updated'}." }
        end
      rescue => e
        respond_to do |format|
          if params[:action] === 'update'
            format.html { redirect_to edit_admin_practice_partner_path(PracticePartner.friendly.find(params[:id])), flash: { error:  "#{e.message}"} }
          else
            format.html { redirect_to new_admin_practice_partner_path, flash: { error:  "#{e.message}"} }
          end
        end
      end
    end

    def create
      create_or_update_practice_partner
    end

    def update
      create_or_update_practice_partner
    end

    def update_partner_practices
      # remove the first practice partner id -- first is always an empty string
      selected_practices = params[:practice_partner][:practice_ids].drop(1)
      selected_practices.map! { |p| p.to_i }
      practice_partner = PracticePartner.find_by(name: params[:practice_partner][:name])
      current_partner_practices = PracticePartnerPractice.where(practice_partner_id: practice_partner[:id]) unless practice_partner.nil?

      if selected_practices.length > 0 && practice_partner.present?
        selected_practices.map { |p| PracticePartnerPractice.find_or_create_by!(practice_id: p, practice_partner_id: practice_partner[:id]) }
      end

      if params[:action] === 'update' && current_partner_practices.present?
        if selected_practices.empty?
          current_partner_practices.map { |p| p.destroy! }
        else
          current_partner_practices.map { |p| p.destroy! unless selected_practices.include? p.practice_id }
        end
      end
    end

    def set_selected_practices
      @practice_partner_practices = []
      current_practices = PracticePartnerPractice.where(practice_partner_id: params[:id])
      unless current_practices.empty?
        current_practices.map do |cp|
          @practice_partner_practices.push(cp[:practice_id])
        end
      end
    end
  end
end
