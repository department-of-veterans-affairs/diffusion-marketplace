ActiveAdmin.register Page do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :page_group_id, :slug, :description,
                page_components_attributes: [:id, :component_type, :position, :_destroy,
                                             component_attributes: [:url, :description, :title, :text, :heading_type, :subtopic_title, :subtopic_description, practices: []]]
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  show do
    attributes_table do
      row('Complete URL') { |page|
        page_link = page.slug == 'home' ? "/#{page.page_group.friendly_id}" : "/#{page.page_group.friendly_id}/#{page.slug}"
        link_to(page_link, page_link, target: '_blank', title: 'opens page in new tab')
      }
      row :page_group
      row :slug
      row :title
      row :description
      row :created_at
      row :updated_at
      row 'Components' do |p|
        p.page_components.each do |pc|
          component = eval("#{pc.component_type}.find(#{pc.component_id})")
          para pc.component_type
          para component&.heading_type if pc.component_type == 'PageHeaderComponent'
          para component&.subtopic_title if pc.component_type == 'PageHeader2Component'
          para component&.subtopic_description if pc.component_type == 'PageHeader2Component'
          para component&.text.html_safe unless pc.component_type == 'PagePracticeListComponent' || pc.component_type == 'PageHeader2Component' || pc.component_type == 'PageSubpageHyperlinkComponent'
          para component&.practices.join(', ') if pc.component_type == 'PagePracticeListComponent'
          para component&.title if pc.component_type == 'PageSubpageHyperlinkComponent'
          para component&.url if pc.component_type == 'PageSubpageHyperlinkComponent'
        end
      end
    end
    active_admin_comments
  end


  form :html => {:multipart => true} do |f|
    f.semantic_errors *f.object.errors.keys # shows errors on :base
    f.inputs "Page Information" do
      f.input :slug, label: 'URL suffix', hint: 'Enter a brief and descriptive page URL suffix (Ex: "page-title"). Note: to make a page the home or landing page for a page group, enter "home".'
      f.input :title, label: 'Title', hint: 'The main heading/"H1" of the page.'
      f.input :description, label: 'Description', hint: 'Overall purpose of the page.'
      f.input :page_group, label: 'Group', hint: 'The Group is the page type and will be included in the url. (Ex: "/competitions/page-title" where "competitions" is the Group and "page-title" is the chosen url suffix from above. If the url suffix is "home", the complete URL will be "/competitions")'
    end

    f.inputs "Page Components" do
      f.has_many :page_components, heading: nil, sortable: :position, sortable_start: 1, allow_destroy: true do |pc, index|
        # TODO: get the placeholder how active admin does "NEW_#{association_human_name.upcase.split(' ').join('_')}_RECORD"
        placeholder = pc.object.component_id ? index - 1 : 'NEW_PAGE_COMPONENT_RECORD'
        component = pc.object.component_id ? eval("#{pc.object.component_type}.find(#{pc.object.component_id})") : nil

        pc.input :component_type, input_html: {class: 'polyselect', 'data-component-id': placeholder}, collection: PageComponent::COMPONENT_SELECTION

        # render partial: 'page_header_component_form', locals: {f: pc, component: component.class == PageHeaderComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_header2_component_form', locals: {f: pc, component: component.class == PageHeader2Component ? component : nil, placeholder: placeholder}
        render partial: 'page_paragraph_component_form', locals: {f: pc, component: component.class == PageParagraphComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_practice_list_component_form', locals: {f: pc, component: component.class == PagePracticeListComponent ? component : nil, placeholder: placeholder}
        render partial: 'page_subpage_hyperlink_component_form', locals: {f: pc, component: component.class == PageSubpageHyperlinkComponent ? component : nil, placeholder: placeholder}

      end
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

  controller do
    before_create do |page|

    end

    before_update do |page|

    end
  end

end
