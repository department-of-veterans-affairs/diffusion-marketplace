ActiveAdmin.register Page do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :category, :slug, page_component_attributes: [:component_type, component_attributes: [:text]]
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form :html => {:multipart => true} do |f|
    f.semantic_errors *f.object.errors.keys # shows errors on :base
    f.inputs "Page Information" do
      f.input :title, label: 'Title', hint: 'The title of the page.'
      f.input :page_category, label: 'Category'
      f.input :slug, label: 'URL', hint: 'Enter a valid, browseable, url for your page to use, ex.: "page-title"'
    end
    f.inputs "Page Components" do
      f.has_many :page_components, heading: nil, sortable: :position, sortable_start: 1 do |pc|
        pc.input :component_type, input_html: {class: 'polyselect'}, collection: PageComponent::COMPONENT_TYPES
        pc.inputs 'Header',
                  for: [:component, pc.object.component || PageHeaderComponent.new],
                  id: 'PageHeaderComponent_poly', class: 'inputs ' do |phc|
          phc.input :text, hint: 'Make this header stand out'
        end
        # debugger
      end
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

end
