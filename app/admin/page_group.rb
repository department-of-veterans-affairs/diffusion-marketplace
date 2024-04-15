ActiveAdmin.register PageGroup do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :name, :description, :slug, :has_landing_page
  remove_filter :editor_roles, :roles

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end

    f.inputs "Editors", class: 'inputs' do
      if f.object.persisted?
        li do
          label "Current Editors", for: "current_editors", class: "label"
          if f.object.editors.any?
            ul id: 'current_editors', style: 'margin-left: 340px;' do
              f.object.editors.each do |editor|
                li class: 'margin-bottom-1' do
                  span editor.email
                  span class: 'margin-left-1' do
                    f.check_box(:remove_editors, { multiple: true, name: "page_group[remove_editors][]"}, editor.id, nil)
                    span " Delete", class: 'margin-left-1'
                  end
                end
              end
            end
          else
            span "No editors assigned", class: 'placeholder'
          end
        end
      end
      f.input :new_editors,
              label: 'Add Community Editor(s)',
              as: :text,
              input_html: { class: 'height-7'},
              hint: "Enter VA emails as a comma-separated list, e.g. marketplace@va.gov, test@va.gov"
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :slug
      row :description
      row "Editors" do |pg|
        ul do
          pg.editors.each do |editor|
            li editor.email
          end
        end
      end
    end
  end

  controller do
    before_action :set_page_group, only: [:create, :update]

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
      @page_group = PageGroup.new(page_group_params.except(:new_editors, :remove_editors))
      ActiveRecord::Base.transaction do
        non_existent_emails, success = @page_group.add_editor_roles_by_emails(params[:page_group][:new_editors]) if params[:page_group][:new_editors].present?

        unless success
          flash.now[:error] = "Page group could not be created. User not found with email(s): #{non_existent_emails.join(', ')}"
          render :new and return
        end

        if @page_group.save
          redirect_to admin_page_group_path(@page_group), notice: 'Page group was successfully created.'
        else
          render :new
        end
      end
    end

    def update
      ActiveRecord::Base.transaction do
        @page_group.assign_attributes(page_group_params.except(:remove_editors, :new_editors))
        if @page_group.save
          if update_editors
            redirect_to admin_page_group_path(@page_group), notice: 'Page group was successfully updated.'
          else
            raise ActiveRecord::Rollback
          end
        else
          render :edit
        end
      rescue ActiveRecord::Rollback
        flash.now[:error] = @error_message if @error_message
        render :edit
      end
    end

    private

    def update_editors
      if params[:page_group][:remove_editors].present?
        @page_group.remove_editor_roles(params[:page_group][:remove_editors])
      end

      if params[:page_group][:new_editors].present?
        non_existent_emails, success = @page_group.add_editor_roles_by_emails(params[:page_group][:new_editors])
        unless success
          @error_message = "User not found with email(s): #{non_existent_emails.join(', ')}"
          return false
        end
      end

      true
    end
  end
end
