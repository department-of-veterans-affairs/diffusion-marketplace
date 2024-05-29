ActiveAdmin.register Page, namespace: :editor do
  menu priority: 1

  actions :all, except: [:destroy]

  config.filters = false
  config.batch_actions = false

  permit_params :title,
                :page_group_id,
                :slug,
                :description,
                :published,
                :ever_published,
                :is_visible,
                :is_public,
                :template_type,
                :has_chrome_warning_banner,
                :image,
                :image_alt_text,
                :delete_image_and_alt_text,
                :is_community_page,
                :short_name,
                page_components_attributes: [
                  :id,
                  :component_type,
                  :position,
                  :_destroy,
                  component_attributes: [
                    :authors,
                    :url,
                    :description,
                    :title,
                    :title1,
                    :title2,
                    :title3,
                    :text,
                    :text1,
                    :text2,
                    :text3,
                    :heading_type,
                    :subtopic_title,
                    :subtopic_description,
                    :alignment,
                    :page_image,
                    :image,
                    :image_alt_text,
                    :caption,
                    :alt_text,
                    :html_tag,
                    :display_name,
                    :attachment,
                    :cta_text,
                    :button_text,
                    :has_background_color,
                    :card,
                    :display_successful_adoptions,
                    :display_in_progress_adoptions,
                    :display_unsuccessful_adoptions,
                    :map_info_window_text,
                    :description_text_alignment,
                    :body,
                    :citation,
                    :text_alignment,
                    :url_link_text,
                    :published_date,
                    :published_in,
                    :published_on_day,
                    :published_on_month,
                    :published_on_year,
                    :has_border,
                    :start_date,
                    :end_date,
                    :location,
                    :presented_by,
                    :flipped_ratio,
                    :hide_after_date,
                    practices: []
                  ],
                ]

  index download_links: false do
    selectable_column
    column(:title) { |page| link_to(page.title, admin_page_path(page)) }
    column(:page_group)
    column(:slug)
    column(:complete_url) { |page|
      page_link = page.slug == 'home' ? "/#{page.page_group.friendly_id}" : "/#{page.page_group.friendly_id}/#{page.slug}"
      page_link = page_link.downcase
      link_to(page_link, page_link, target: '_blank', title: 'opens page in new tab')
    }
    column(:description)
    column(:published)
    actions do |page|
      publish_action_str = page.published ? "Unpublish" : "Publish"
      item publish_action_str, publish_page_admin_page_path(page), method: :post
    end
  end

  show do
    attributes_table do
      row('Complete URL') { |page|
        page_link = page.slug == 'home' ? "/#{page.page_group.friendly_id}" : "/#{page.page_group.friendly_id}/#{page.slug}"
        page_link = page_link.downcase
        link_to(page_link, page_link, target: '_blank', title: 'opens page in new tab')
      }
      row :page_group
      row :slug
      row :is_community_page
      row :template_type
      row :title
      row :short_name
      row :description
      row :has_chrome_warning_banner
      row :published
      row :is_public
      if resource.image.present?
        row(:image) { |page| img src: "#{page.image_s3_presigned_url(:thumb)}", class: 'maxw-10' }
        row(:image_alt_text)
      end
      row :created_at
      row :updated_at
      row 'Components' do |p|
        p.page_components.map { |pc|
          component = eval("#{pc.component_type}.find('#{pc.component_id}')")
          Arbre::Context.new do
            para do
              b "#{PageComponent::COMPONENT_SELECTION.key(pc.component_type)}"
            end
            if component.class.const_defined? :FORM_FIELDS
              ul do
                component.class::FORM_FIELDS.each do | key, value|
                  if key == :practices # Render list of practice IDs as a list of practice names
                    li "#{component&.practices.length} Practice#{component&.practices.length == 1 ? '' : 's'} selected: "
                    para component&.practices.map {|pid| Practice.find(pid).name }.join("\n")
                  elsif key == :image && (component.try(:page_image_file_name).present? || component.image_file_name.present?) # render image thumbnail
                    li do
                      img src: "#{component.image_s3_presigned_url}", class: 'maxw-10'
                    end
                  else
                    li "#{value}: #{component.send(key)}" if (component.send(key) == false || component.send(key).present?)
                  end
                end
              end
            end
          end
        }.join('').html_safe
      end
      row :publish_page do
        if resource.published
          link_to('Unpublish Page', publish_page_admin_page_path, method: :post, class: 'active_admin_action_button')
        else
          link_to('Publish Page', publish_page_admin_page_path, method: :post, class: 'active_admin_action_button')
        end
      end
    end
  end

  member_action :publish_page, method: :post do
    message = "\"#{resource.title.to_s}\" Page published"
    if resource.published
      message = "\"#{resource.title.to_s}\" Page unpublished"
      resource.published = nil
    else
      resource.published = DateTime.now
      unless resource.ever_published
        resource.ever_published = true
      end
    end
    resource.save
    redirect_back fallback_location: root_path, notice: message
  end

  form :html => {:multipart => true} do |f|
    f.actions # adds the 'Submit' and 'Cancel' buttons
    f.semantic_errors *f.object.errors.attribute_names # shows errors on :base
    f.inputs "Page Information" do
      f.input :page_group,
              collection: PageGroup.accessible_by(current_user).pluck(:name, :id),
              label: 'Page Group / Community',
              hint: 'The community name will be included in the URL. (e.g.: "/communities/va-immersive/about-us" where "va-immersive" is the Community and "about-us" is the URL suffix chosen below.'
      if resource.ever_published
        f.input :slug, input_html: { disabled: true } , label: 'URL suffix', hint: 'A hyphenated page name used in the URL. (e.g. "about"). Note: A page with the URL suffix "home" will be the communnity landing page. If this page was ever published, the URL Suffix cannot be edited.'
      else
        f.input :slug, label: 'URL suffix', hint: 'Enter a hyphenated page name used in the URL. (e.g. "about-us"). Note: to create a community homepage, use the suffix "home".'
      end
      f.input :template_type
      f.input :title, label: 'Title', hint: 'The main heading/"H1" of the page.'
      f.input :is_community_page,
              label: 'Community page?',
              as: :boolean,
              hint: 'Add or remove from community sub-nav links'
      f.input :short_name,
              hint: 'Overrides title for use as link text in community sub-nav'
      f.input :description, label: 'Description', hint: 'Overall purpose of the page.'
      f.input :image,
              value: f.resource.image_file_name,
              type: 'file',
              label: 'Image',
              hint: 'File types allowed: jpg, jpeg, and png. Max file size: 25MB',
              input_html: { accept: '.jpg, .jpeg, .png' }
      # Page image preview
      image = f.resource.image
      if image.present?
        div class: 'page-image-preview-container' do
          div class: 'placeholder'
          div class: 'page-image-container' do
            img class: 'page-image', src: f.resource.image_s3_presigned_url(:thumb), alt: f.resource.image_alt_text
          end
        end
      end
      f.input :image_alt_text,
              label: 'Image alternative text (required if image present)',
              as: :text,
              input_html: { class: 'height-7' },
              hint: "Alternative text that gets rendered in case the image cannot be viewed. It should be a brief description of "\
                    "the information this image is trying to convey."
      if image.present?
          f.input :delete_image_and_alt_text,
                  as: :boolean,
                  label: 'Delete image and alternative text',
                  input_html: { class: 'margin-left-2px' }
      end
      f.input :is_visible,
              label: 'Title and Description are visible?',
              hint: 'This field allows you to show or hide the page title and description.'
      f.input :has_chrome_warning_banner,
              label: 'Switch to Chrome warning banner',
              hint: 'Check this if the page has any call to action or link that only works or is optimal in the Chrome Browser.'
      f.input :published,
              input_html: { disabled: true },
              as: :datepicker, label: 'Published',
              hint: 'Date when page was published. This field is readonly. Do not touch.'
      f.input :is_public,
              label: 'Public Page?',
              hint: 'Set access to public or Va-users only.'
    end

    f.inputs "Page Components" do
      render partial: 'page_components_form', locals: {f: f, page_components: :page_components}
    end
    para 'All fields marked with an * are required'
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end


  controller do
    before_action :set_page,
                  only: [:create, :update]
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

    def scoped_collection
      super.includes(:page_group).then do |scope|
        if current_user.has_role?(:admin)
          scope
        else
          editor_page_group_ids = PageGroup.accessible_by(current_user).pluck(:id)
          scope.where(page_group_id: editor_page_group_ids)
        end
      end
    end

    def create
      create_or_update_page
    end

    def update
      create_or_update_page
    end

    private

    def set_page
      @page = Page.find_by(id: params[:id])
    end

    def create_or_update_page
      ActiveRecord::Base.transaction do
        @page ||= Page.new

        delete_page_image_and_alt_text
        page_params = permitted_params[:page]
        @page.update!(page_params)
        update_page_group_position
      end

      redirect_to admin_page_path(@page), notice: "Page was successfully #{action_name == 'create' ? 'created' : 'updated'}."
    end

    def validate_page_description_length(description)
      # raise a standard error if the description for the page is longer than 140 characters (per design on 11/22/21).
      # This adds a custom message to match other page-builder validation errors.
      raise StandardError, 'Validation failed. Page description cannot be longer than 140 characters.' if description.length > 140
    end

    def handle_record_invalid(exception)
      error_message = rewrite_error_message(exception.message)
      redirect_to_correct_path(flash: { error: error_message })
    end

    def rewrite_error_message(error_message)
      return "" unless error_message.is_a?(String)

      error_message = error_message.gsub(/Validation failed: |Page components component /, '')
        error_message = error_message.split(/(?<=\])/).map do |str|
          if str.include?("PageComponent")
            index_of_component_error = str.index("PageComponent")
            str = str.slice(index_of_component_error, str.length)
            str.sub('PageComponent ', '') + "\n"
          else
            str = str.sub(",", "")
            str.prepend("Page errors: [") + "]\n"
          end
        end.join(", ").strip
      error_message
    rescue => e
      Rails.logger.error "Error formatting message: #{e.message}"
      error_message # Return original message if anything goes wrong
    end

    def redirect_to_correct_path(options = {})
      flash = options[:flash] || {}
      path = case action_name
              when 'update'
                edit_editor_page_path(@page)
              when 'create'
                new_editor_page_path
              else
                editor_pages_path
              end

      redirect_to path, flash: flash
    end

    def delete_page_image_and_alt_text
      if @page.present? && params[:page][:delete_image_and_alt_text] === '1'

        params[:page][:image] = nil
        params[:page][:image_alt_text] = nil
      end
    end

    def update_page_group_position
      include_in_community_subnav = (params[:page][:is_community_page] == "1")

      if include_in_community_subnav != @page.is_community_page
        @page.add_or_remove_from_community_subnav
      end
    end
  end
end
