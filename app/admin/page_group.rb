ActiveAdmin.register PageGroup do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :name, :description, :slug, :has_landing_page, :pages_attributes
  remove_filter :editor_roles, :roles

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end

    # TODO: condense 'Editors' and 'Pages' parts of this form into partials to be shared with
    # admin/editor/page_group form
    f.inputs "Editors", class: 'inputs' do
      if f.object.persisted?
        editors = f.object.editors

        li do
          label "Current Editors", for: "current-editors", class: "label"
          if editors.any?
            ul id: 'current-editors', class: 'current-editors margin-left-3' do
              editors.each do |editor|
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
            span "No editors assigned", class: 'no-editors-assigned display-block margin-top-1 text-italic text-base-dark'
          end
        end
      end
      f.input :new_editors,
              label: 'Add Community Editor(s)',
              as: :text,
              input_html: { class: 'height-7'},
              hint: "Enter VA emails as a comma-separated list, e.g. marketplace@va.gov, test@va.gov"
    end

    f.inputs 'Pages', class: 'inputs' do
      if f.object.persisted?
        community_pages = f.object.pages.community_pages.to_a

        li class: 'padding-bottom-2 margin-bottom-2 border-bottom-1px border-base-light' do
          label "Community sub-nav link ordering", for: "current-pages text-no-wrap", class: "label"
          if community_pages.any?
            ul id: 'current-pages', class: 'margin-x-3 display-flex' do
              community_pages.each_with_index do |page, index|
                li class: 'margin-bottom-1 margin-right-1', data: { page_id: page.id } do
                  span class: 'handle text-no-wrap' do
                    span page.short_name.present? ? page.short_name : page.title
                    span class: "fa fa-stack margin-left-05" do
                      i class: "fa fa-caret-left margin-left-05"
                      i class: "fa fa-caret-right margin-left-05"
                    end
                  end
                  f.hidden_field :id, value: page.id, name: "page_group[pages_attributes][#{index}][id]"
                  f.hidden_field :position, value: page.position, name: "page_group[pages_attributes][#{index}][position]"
                end
              end
            end
            span "Drag and drop to adjust position of links as seen in community sub-nav", class: 'drag-position-hint display-block text-italic text-base-dark'
            span "Uses Page's TITLE as link text if SHORT NAME is blank", class: 'drag-position-hint display-block text-italic text-base-dark padding-bottom-1'
          else
            span "No pages assigned", class: 'no-community-pages display-block text-italic text-base-dark padding-bottom-1'
          end
        end

        li class: 'margin-top-1'do
          non_community_pages = f.object.pages.where(position: nil)
          label "Pages not in community sub-nav", for: "unpositioned-pages", class: "label"
          if non_community_pages.any?
            ul class: 'unpositioned-pages' do
              non_community_pages.each do |page|
                li class: 'margin-bottom-1' do
                  link_to page.title, edit_editor_page_path(page)
                end
              end
            end
            span "Visit a Page's edit screen to add or remove as link in community sub-nav", class: 'unpositioned-page-hint display-block margin-top-1 text-italic text-base-dark'
          else
            span "No pages assigned", class: 'no-unpositioned-pages display-block margin-top-1 text-italic text-base-dark'
          end
        end
      end
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
      row "Community Pages" do |pg|
        community_pages = pg.pages.where.not(position: nil).to_a
        ul do
          community_pages.each do |page|
            li link_to page.title, edit_admin_page_path(page)
          end
        end
      end

      row "Non-Community Pages" do |pg|
        non_community_pages = pg.pages.where(position: nil)
        ul do
          non_community_pages.each do |page|
            li link_to page.title, edit_admin_page_path(page)
          end
        end
      end
    end
  end

  controller do
    before_action :set_page_group, only: [:create, :update]

    def page_group_params
      params.require(:page_group).permit(:name, :description, :slug, :has_landing_page, pages_attributes: {}, editors: [])
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

      if params[:page_group][:new_editors].present?
        users_to_add_roles, non_existent_emails = validate_editor_emails
        if non_existent_emails.present?
          flash.now[:error] = "Page group could not be created. User not found with email(s): #{non_existent_emails.join(', ')}"
          render :new and return
        end
      end

      ActiveRecord::Base.transaction do
        @page_group.save!
        add_editor_roles(users_to_add_roles) if users_to_add_roles.present?
      end

      redirect_to admin_page_group_path(@page_group), notice: 'Page group was successfully created.'
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end


    def update
      ActiveRecord::Base.transaction do
        @page_group.assign_attributes(page_group_params.except(:remove_editors, :new_editors, :pages_attributes))

        if @page_group.save
          if update_editors && update_pages
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
        users_to_add_roles, non_existent_emails = validate_editor_emails

        if non_existent_emails.present?
          @error_message = "User not found with email(s): #{non_existent_emails.join(', ')}"
          return false
        elsif users_to_add_roles.present?
          add_editor_roles(users_to_add_roles)
          return true
        end
      end

      true
    end

    def update_pages
      if params[:page_group][:pages_attributes].present?
        params[:page_group][:pages_attributes].each do |_, page_params|
          page = @page_group.pages.find(page_params[:id])
          page.update(position: page_params[:position])
        end
      end
      true
    end

    def validate_editor_emails
      editor_emails = params[:page_group][:new_editors].split(',').map(&:strip).uniq
      User.validate_users_by_emails(editor_emails)
    end

    def add_editor_roles(users_to_add_roles)
      users_to_add_roles.each { |user| user.add_role(User::USER_ROLES[1], @page_group) }
    end
  end
end
