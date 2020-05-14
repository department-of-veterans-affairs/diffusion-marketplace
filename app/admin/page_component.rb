ActiveAdmin.register PageComponent do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
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

    f.inputs "Component" do

      f.input :component_type, input_html: {class: 'polyselect'}, collection: PageComponent::COMPONENT_TYPES
      f.inputs 'Header',
               for: [:component, f.object.component || PageHeaderComponent.new],
               id: 'PageHeaderComponent_poly', class: 'inputs polyform' do |phc|
        phc.input :text, hint: 'Make this header stand out'
      end

    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end
end
