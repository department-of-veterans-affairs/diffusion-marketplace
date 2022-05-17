ActiveAdmin.register Page do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :page_group_id, :slug, :description, :published, :ever_published, :is_visible, :template_type, :has_chrome_warning_banner,
                page_components_attributes: [
                  :id, :component_type, :position, :_destroy, component_attributes: [
                    :url, :description, :title, :text, :heading_type, :subtopic_title, :subtopic_description, :alignment,
                    :page_image, :caption, :alt_text, :html_tag, :display_name, :attachment, :cta_text, :button_text, :card, practices: []
                  ]
                ]

  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #
  index do
    selectable_column
    column(:title) { |page| link_to(page.title, admin_page_path(page)) }
    column(:page_group)
    column(:slug)
    column(:complete_url) { |page|
      page_link = page.slug == 'home' ? "/#{page.page_group.friendly_id}" : "/#{page.page_group.friendly_id}/#{page.slug}"
      page_link = page_link.downcase
      link_to(page_link, page_link, target: '_blank', title: 'opens page in new tab')
    }
    column(:description) { |page|
      page.description.truncate(200)
    }
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
      row :template_type
      row :title
      row :description
      row :has_chrome_warning_banner
      row :published
      row :created_at
      row :updated_at
      row 'Components' do |p|
        p.page_components.map { |pc|
          component = eval("#{pc.component_type}.find('#{pc.component_id}')")
          Arbre::Context.new do
            para do
              b "#{PageComponent::COMPONENT_SELECTION.key(pc.component_type)} #{'(Card)' if pc.component_type == 'PageSubpageHyperlinkComponent' && component&.card?}"
            end
            para component&.heading_type if pc.component_type == 'PageHeaderComponent'
            para component&.subtopic_title if pc.component_type == 'PageHeader2Component'
            para component&.subtopic_description if pc.component_type == 'PageHeader2Component'
            para "Alignment: #{component&.alignment}" if pc.component_type == 'PageHeader3Component'
            para component&.title if pc.component_type == 'PageHeader3Component' || pc.component_type == 'PageSubpageHyperlinkComponent' || pc.component_type == 'PageAccordionComponent'
            para component&.description if pc.component_type == 'PageHeader3Component'
            para component&.text.html_safe unless pc.component_type == 'PageHrComponent' || pc.component_type == 'PagePracticeListComponent' || pc.component_type == 'PageHeader2Component' || pc.component_type == 'PageSubpageHyperlinkComponent' || pc.component_type == 'PageHeader3Component' || pc.component_type == 'PageYouTubePlayerComponent' || pc.component_type == 'PageImageComponent' || pc.component_type == 'PageDownloadableFileComponent' || pc.component_type == 'PageCtaComponent'
            para "#{component&.practices.length} Practice#{component&.practices.length == 1 ? '' : 's'}" if pc.component_type == 'PagePracticeListComponent'
            para component&.practices.map {|pid| Practice.find(pid).name }.join("\n") if pc.component_type == 'PagePracticeListComponent'
            para component&.url if pc.component_type == 'PageSubpageHyperlinkComponent' || pc.component_type == 'PageYouTubePlayerComponent'
            para component&.caption if pc.component_type == 'PageYouTubePlayerComponent'
            para component&.alt_text if pc.component_type == 'PageImageComponent'
            para component&.attachment_file_name if pc.component_type == 'PageDownloadableFileComponent'
            para component&.display_name if pc.component_type == 'PageDownloadableFileComponent' && component&.display_name != ''
            para component&.description if pc.component_type == 'PageDownloadableFileComponent' && component&.description != ''
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
    active_admin_comments
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
    f.semantic_errors *f.object.errors.keys # shows errors on :base
    f.inputs "Page Information" do
      if resource.ever_published
        f.input :slug, input_html: { disabled: true } , label: 'URL suffix', hint: 'Enter a brief and descriptive page URL suffix (Ex: "page-title"). Note: to make a page the home or landing page for a page group, enter "home". If this page was ever published, the URL Suffix cannot be edited.'
      else
        f.input :slug, label: 'URL suffix', hint: 'Enter a brief and descriptive page URL suffix (Ex: "page-title"). Note: to make a page the home or landing page for a page group, enter "home".'
      end
      f.input :template_type
      f.input :title, label: 'Title', hint: 'The main heading/"H1" of the page.'
      f.input :description, label: 'Description', hint: 'Overall purpose of the page.'
      f.input :is_visible, label: 'Title and Description are visible?', hint: 'This field allows you to show or hide the page title and description.'
      f.input :page_group, label: 'Group', hint: 'The Group is the page type and will be included in the url. (Ex: "/competitions/page-title" where "competitions" is the Group and "page-title" is the chosen url suffix from above. If the url suffix is "home", the complete URL will be "/competitions")'
      f.input :has_chrome_warning_banner, label: 'Switch to Chrome warning banner', hint: 'Check this if the page has any call to action or link that only works or is optimal in the Chrome Browser.'
      f.input :published, input_html: { disabled: true }, as: :datepicker, label: 'Published', hint: 'Date when page was published. This field is readonly. Do not touch.'
    end

    f.inputs "Page Components" do
      render partial: 'page_components_form', locals: {f: f, page_components: :page_components}
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons

    # to fix two submit buttons with the same id and name
    script do
      raw "$(document).ready(function($) {
                        $.each($('.input_action'), function(i, e) {
                            e.id = e.id + '_' + i;
                            $('#' + e.id + ' input').attr('name', 'commit_' + i);
                        });
                      });
                    "
    end
    script do
      raw "function initTinyMCE(selector) {
        tinymce.init({
              selector: selector,
              menubar: false,
              plugins: 'link, lists',
              toolbar:
                'undo redo | styleselect | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | forecolor backcolor | link bullist numlist superscript subscript | outdent indent | removeformat',
              link_title: false,
              link_assume_external_targets: false
            });
        }"
    end
    # load tinymce for new accordions or paragraph components
    script do
      raw "$(document).change('.polyselect', function(e) {
        var componentType = $(e.target).val();
        var componentId = $(e.target).data('componentId');
        var typeText;
        if (componentType === 'PageAccordionComponent') {
          typeText = 'accordion';
        } else if (componentType === 'PageParagraphComponent') {
          typeText = 'paragraph';
        }
        var componentTextareaId = '#page_page_components_attributes_' + typeText + '_' + componentId + '_component_attributes_text'
          if (componentType === 'PageAccordionComponent' || componentType === 'PageParagraphComponent') {
            initTinyMCE(componentTextareaId)
          }
        })"
    end
    # reloads tinymce when drag and dropping
    script do
      raw "$(document).on('mouseup','.handle', function(e) {
            var componentType = $(e.target).closest('ol').find('.polyselect').val();
            if (componentType === 'PageParagraphComponent' || componentType === 'PageAccordionComponent') {
              var textareaContainer = $(e.target).closest('ol').find(`.polyform[style*='list-item']`);
              var dmTinyMCE = $(textareaContainer).find('textarea.tinymce').attr('id');
              tinymce.get(dmTinyMCE).remove();
              initTinyMCE('#' + dmTinyMCE);
            }
         })"
    end
    # remove extra tinymce classes for color dropdowns that are being added
    script do
      raw "$(document).arrive('.tox.tox-silver-sink.tox-tinymce-aux', function(e) {
            var componentCount = $('.ui-sortable').find('.page_components').length;
            if ($('.tox.tox-silver-sink.tox-tinymce-aux').length > (componentCount * 2)) {
              $(e).remove();
            }
          })"
    end
  end


  controller do
    def create
      create_or_update_page
    end

    def update
      create_or_update_page
    end

    private

    def create_or_update_page
      begin
        page_params = params[:page]
        page_description = page_params[:description]
        page_id = params[:id]
        page = page_id.present? ? Page.find(page_id) : nil
        # raise a standard error if the description for the page is longer than 140 characters (per design on 11/22/21). This adds a custom message to match other page-builder validation errors.
        raise StandardError.new 'Validation failed. Page description cannot be longer than 140 characters.' if page_description.length > 140

        if page.nil?
          page = Page.create!(permitted_params[:page])
        else
          page.update(permitted_params[:page])
        end

        respond_to do |format|
          format.html { redirect_to admin_page_path(page), notice: "Page was successfully #{params[:action] === 'create' ? 'created' : 'updated'}." }
        end
      rescue => e
        respond_to do |format|
          if params[:action] === 'update'
            format.html { redirect_to edit_admin_page_path(page), flash: { error:  "#{e.message}"} }
          else
            format.html { redirect_to new_admin_page_path, flash: { error:  "#{e.message}"} }
          end
        end
      end
    end
  end
end
