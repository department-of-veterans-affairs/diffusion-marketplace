ActiveAdmin.register PageGroup, namespace: :editor do
  actions :all, except: [:destroy, :new]

  config.filters = false
  config.batch_actions = false

  permit_params :name, :description, :slug, :has_landing_page, :new_editors, :pages_attributes

  form do |f|
    f.inputs "Editors", class: 'inputs' do
      if f.object.persisted?
        editors = f.object.editors

        li do
          label "Current Editors", for: "current_editors", class: "label"
          if editors.any?
            ul id: 'current_editors', class: 'page_group_editors-list' do
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

    f.inputs 'Pages', class: 'inputs' do
      if f.object.persisted?
        community_pages = f.object.pages.community_pages.to_a

        li class: 'community-nav-section' do
          label "Community sub-nav link ordering", for: "current_pages", class: "label"
          if community_pages.any?
            ul id: 'current_pages', class: 'community-nav-pages-list' do
              community_pages.each_with_index do |page, index|
                li class: 'margin-bottom-1', data: { page_id: page.id } do
                  span class: 'handle' do
                    span page.short_name.present? ? page.short_name : page.title
                    span class: "fa fa-stack" do
                      i class: "fa fa-caret-up"
                      i class: "fa fa-caret-down"
                    end
                  end
                  f.hidden_field :id, value: page.id, name: "page_group[pages_attributes][#{index}][id]"
                  f.hidden_field :position, value: page.position, name: "page_group[pages_attributes][#{index}][position]"
                end
              end
            end
            span "Drag to adjust position of links as seen in community sub-nav", class: 'drag-position-hint'
            span "Uses Page's TITLE as link text if COMMUNITY SUBNAV LINK TEXT is blank, update in Page's edit form", class: 'drag-position-hint'
          else
            span "No pages assigned", class: 'no-community-pages'
          end
        end

        li do
          non_community_pages = f.object.pages.where(position: nil)
          label "Pages not in community sub-nav", for: "unpositioned_pages", class: "label"
          if non_community_pages.any?
            ul id: 'unpositioned_pages', class: 'community-nav-pages-list' do
              non_community_pages.each do |page|
                li class: 'margin-bottom-1' do
                  link_to page.title, edit_editor_page_path(page)
                end
              end
            end
            span "Visit a Page's edit screen to add or remove as link in community sub-nav", class: 'unpositioned-page-hint'
          else
            span "No pages assigned", class: 'no-unpositioned-pages'
          end
        end
      end
    end

    f.actions
  end

  index download_links: false

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

    def scoped_collection
      super.then do |scope|
        if current_user.has_role?(:admin)
          scope
        else
          editor_page_group_ids = PageGroup.accessible_by(current_user).pluck(:id)
          scope.where(id: editor_page_group_ids)
        end
      end
    end

    def page_group_params
      params.require(:page_group).permit(pages_attributes: {}, editors: [])
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
            redirect_to editor_page_group_path(@page_group), notice: 'Page group was successfully updated.'
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
