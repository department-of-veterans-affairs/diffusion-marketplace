### DO NOT CHECK IN CHANGES
### Uncomment this file to develop the PageComponents.
### The idea is that you can use the "f.inputs" in the partial
### that is being developed to look at the rendered html in the browser to
### build the Arbre::Context for the parital.
### See page_header_component_form.html.arb as an example.

# ActiveAdmin.register PageComponent do
#   # See permitted parameters documentation:
#   # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#   #
#   # permit_params :list, :of, :attributes, :on, :model
#   #
#   # or
#   #
#   # permit_params do
#   #   permitted = [:permitted, :attributes]
#   #   permitted << :other if params[:action] == 'create' && current_user.admin?
#   #   permitted
#   # end
#   form :html => {:multipart => true} do |f|
#     f.semantic_errors *f.object.errors.keys # shows errors on :base
#
#     f.inputs "Component" do
#
#       f.input :component_type, input_html: {class: 'polyselect'}, collection: PageComponent::COMPONENT_TYPES
#       # We can also render partials here to check the form
#       f.inputs 'Header Example',
#                for: [:component, f.object.component || PageHeaderComponent.new],
#                id: 'PageHeaderComponent_poly', class: 'inputs' do |phc|
#         phc.input :heading_type, collection: %w(H1 H2 H3 H4 H5 H6), hint: 'Choose a heading type where H1 is the largest font-size and H6 is a smaller, yet still bolder, font-size.'
#         phc.input :text, hint: 'Make this header stand out'
#         debugger
#       end
#
#     end
#     f.actions # adds the 'Submit' and 'Cancel' buttons
#   end
# end
