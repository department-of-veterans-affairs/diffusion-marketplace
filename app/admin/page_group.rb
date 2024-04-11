ActiveAdmin.register PageGroup do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :name, :description, :slug, :has_landing_page
  remove_filter :editor_roles, :roles

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :editors,
              label: 'Commmunity editors',
              as: :text,
              input_html: { class: 'height-7', value: f.object.editors_emails_string },
              hint: "Enter VA emails as a comma-separated list, e.g. marketplace@va.gov,test@va.gov"
    end

    f.actions
  end

  controller do
    before_action :set_page_group, only: [:create, :update]
    before_action :validate_editor_emails, only: [:create, :update]

    def page_group_params
      params.require(:page_group).permit(:name, :description, :slug, :has_landing_page, editors: [])
    end

    def set_page_group
      page_group_slug = params[:id]
      @page_group = page_group_slug.present? ? PageGroup.find_by(slug: page_group_slug) : nil
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create
      @page_group = PageGroup.new(page_group_params.except(:editors))
      super do |success, failure|
        success.html do
          update_editors(params[:page_group][:editors]) if @page_group.persisted?
          redirect_to admin_page_group_path(@page_group), notice: 'Page group was successfully created.'
        end
        failure.html { render :new }
      end
    end

    def update
      super do |success, failure|
        success.html do
          update_editors(params[:page_group][:editors])
          redirect_to admin_page_group_path(resource), notice: 'Page group was successfully updated.'
        end
        failure.html { render :edit }
      end
    end

    private

    def validate_editor_emails
      non_existent_emails = find_invalid_emails(params[:page_group][:editors])
      if non_existent_emails.present?
        flash[:alert] = "User not found with email(s): #{non_existent_emails.join(', ')}"
        redirect_back(fallback_location: admin_page_groups_path, alert: "User not found with email(s): #{non_existent_emails.join(', ')}") and return
      end
    end

    def find_invalid_emails(editors_string)
      submitted_emails = editors_string.to_s.split(',').map(&:strip).uniq
      existing_emails = User.where(email: submitted_emails).pluck(:email)
      submitted_emails - existing_emails
    end

    def update_editors(editors_string)
      return if editors_string.blank?

      users = User.where(email: editors_string.split(',').map(&:strip))

      ActiveRecord::Base.transaction do
        @page_group.editors.each do |editor|
          editor.remove_role :page_group_editor, @page_group
        end

        users.each do |user|
          user.add_role :page_group_editor, @page_group
        end
      end
    end
  end
end
