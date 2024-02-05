ActiveAdmin.register PageGroup do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :description, :slug, :has_landing_page
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  remove_filter :roles
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :editors, # or roles? 
              label: 'Commmunity editors',
              as: :text,
              input_html: { class: 'height-7' },
              hint: "Enter VA emails as a comma-separated list, e.g. marketplace@va.gov,test@va.gov"
      # if image.present?
      #     f.input :delete_image_and_alt_text,
      #             as: :boolean,
      #             label: 'Delete image and alternative text',
      #             input_html: { class: 'margin-left-2px' }
      # end
    end

    f.actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create
      # add a new role
      # should we require an editor for this field? 

      super
    end

    def update

      # delete users' roles if editors is empty

      super
    end
  end
end
