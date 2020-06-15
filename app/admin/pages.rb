ActiveAdmin.register Page do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :page_group_id, :slug, :description, :published, :ever_published, :is_visible, :template_type, :has_chrome_warning_banner,
                page_components_attributes: [:id, :component_type, :position, :_destroy,
                component_attributes: [:url, :description, :title, :text, :heading_type, :subtopic_title, :subtopic_description, :alignment, :page_image, :caption, :alt_text, :html_tag, :display_name, :attachment, :cta_text, :button_text, practices: []]]

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
      row :published
      row :created_at
      row :updated_at
      row 'Components' do |p|
        p.page_components.map { |pc|
          component = eval("#{pc.component_type}.find('#{pc.component_id}')")
          Arbre::Context.new do
            para do
              b PageComponent::COMPONENT_SELECTION.key(pc.component_type)
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
      row :has_chrome_warning_banner
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
      f.input :published, input_html: { disabled: true }, as: :datepicker, label: 'Published', hint: 'Date when page was published. This field is readonly. Do not touch.'
      f.input :has_chrome_warning_banner, label: 'Switch to Chrome warning banner', hint: 'Check this if the Page has any call to action or link that only works or is optimal in the Chrome Browser.'
    end

    f.inputs "Page Components" do
      f.has_many :page_components, heading: nil, sortable: :position, sortable_start: 1, allow_destroy: true, class: 'page_components' do |pc, index|
        # TODO: get the placeholder how active admin does "NEW_#{association_human_name.upcase.split(' ').join('_')}_RECORD"
        placeholder = pc.object.component_id ? index - 1 : 'NEW_PAGE_COMPONENT_RECORD'
        component = pc.object.component_id ? eval("#{pc.object.component_type}.find('#{pc.object.component_id}')") : nil

        pc.input :component_type, input_html: {class: 'polyselect', 'data-component-id': placeholder}, collection: PageComponent::COMPONENT_SELECTION
        # render partial: 'page_header_component_form', locals: {f: pc, component: component.class == PageHeaderComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_header2_component_form', locals: {f: pc, component: component.class == PageHeader2Component ? component : nil, placeholder: placeholder}
        render partial: 'page_header3_component_form', locals: {f: pc, component: component.class == PageHeader3Component ? component : nil, placeholder: placeholder}
        render partial: 'page_paragraph_component_form', locals: {f: pc, component: component.class == PageParagraphComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_practice_list_component_form', locals: {f: pc, component: component.class == PagePracticeListComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_subpage_hyperlink_component_form', locals: {f: pc, component: component.class == PageSubpageHyperlinkComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_accordion_component_form', locals: {f: pc, component: component.class == PageAccordionComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_you_tube_player_component_form', locals: {f: pc, component: component.class == PageYouTubePlayerComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_image_component_form', locals: {f: pc, component: component.class == PageImageComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_hr_component_form', locals: {f: pc, component: component.class == PageHrComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_downloadable_file_component_form', locals: {f: pc, component: component.class == PageDownloadableFileComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_cta_component_form', locals: {f: pc, component: component.class == PageCtaComponent ? component : nil, placeholder: placeholder}
      end
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
  end

  controller do
    before_create do |page|

    end

    before_update do |page|

    end
  end

end
