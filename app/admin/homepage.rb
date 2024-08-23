ActiveAdmin.register Homepage do
  permit_params :internal_title, :section_title_one, :section_title_two, :section_title_three, :published, homepage_features_attributes: [:id, :title, :description, :url, :cta_text, :featured_image, :featured_image_file_name, :featured_image_content_type, :featured_image_updated_at, :featured_image_file_size, :image_alt_text, :delete_image, :section_id, :homepage_id, :position, :_destroy]


  config.filters = false
  config.sort_order = 'published_asc'

  # # Custom action to publish a homepage
  # member_action :publish, method: :post do
  #   currently_published = resource.published?
  #   resource.update(published: !currently_published)
  #   redirect_to resource_path, notice: "Homepage has been published."
  # end

  # Customizing the action items (buttons) on the show page
  action_item :publish, priority: 0, only: :show do
    publish_action_str = resource.published? ? 'Unpublish' : 'Publish'
    link_to publish_action_str, publish_admin_homepage_path(resource), method: :post
  end

  # action_item :publish, priority: 0, only: :index do
  #   if params[:id].present? && (homepage = Homepage.find_by(id: params[:id]))
  #     link_to "Publish", publish_admin_homepage_path(homepage), method: :post if !homepage.published?
  #   end
  # end

  member_action :publish, priority: 0, method: :post do
    # add logic for unpublishing current homepage
    if resource.published
      message = "\"#{resource.internal_title.to_s}\" unpublished"
      resource.published = false
    else
      message = "\"#{resource.internal_title.to_s}\" published"
      resource.published = true
    end
    resource.save
    redirect_back fallback_location: root_path, notice: message
  end

  index do
    id_column
    column :internal_title
    column :published
    column :updated_at
    actions do |homepage|
      publish_action_str = homepage.published ? "Unpublish" : "Publish"
      item publish_action_str, publish_admin_homepage_path(homepage), method: :post
    end
  end

  show do
    attributes_table do
      row :internal_title
      row :published
      row :updated_at
      row :created_at
    end

    panel "Features" do
      # scope this to just this section
      table_for homepage.homepage_features do
        column :section_id
        column :title
        column :featured_image_file_name
        column :description
        column :url
        column :cta_text
        # image preview
        column :featured_image do |hf|
          image_tag hf&.featured_image&.image_s3_presigned_url(:thumb)
        end
        # column ('Image preview') { |hf| image_tag(:featured_image&.attachment_s3_presigned_url(:thumb)) hf.featured_image? }
        # column image_tag(:featured_image&.attachment_s3_presigned_url(:thumb))
      end
    end
  end

 # form do |f| 
 #    f.inputs do
 #      f.input :title, as: :string, required: true
 #      f.input :description, as: :string, required: true
 #      f.input :url, label: "Call to action URL", as: :string, hint: "Can be an internal (e.g. /partners) or external (e.g. https://www.va.gov) URL", required: true
 #      f.input :cta_text, label: "Call to action text", as: :string, required: true
 #      f.input :attachment, :as => :file, required: true
 #      if topic.attachment.exists?
 #        div '', style: 'width: 20%', class: 'display-inline-block'
 #          div class: 'display-inline-block' do
 #            image_tag(topic.attachment_s3_presigned_url(:thumb))
 #          end
 #        end
 #      end
 #    f.actions
 #  end

    form do |f|  
    f.semantic_errors # shows errors on :base
    f.inputs 'Nickname' do
      f.input :internal_title, as: :string, 
        required: true, 
        hint: 'e.g. September 2024 homepage'
    end
    f.inputs 'Section 1' do
      f.input :section_title_one, required: true, label: 'Section Title', hint: 'e.g. Featured Innovations'
    end

    f.inputs 'Section 2' do
      f.input :section_title_two, required: true, label: 'Section Title', hint: 'e.g. Trending Tags'
    end

    f.inputs 'Section 3' do
      f.input :section_title_three, required: true, label: 'Section Title', hint: 'e.g. Innovation Communities'
    end

    f.has_many :homepage_features, heading: "Features", new_record: 'Add Feature', allow_destroy: true do |t|
      # f.has_many :homepage_features, new_record: 'Add Feature', allow_destroy: true, sortable: :position, sortable_start: 1 do |t|
        t.input :section_id, as: :select, collection: [1,2,3], label: 'Section', hint: "Maximum of 3 features per section"
        t.input :title, label: 'Feature Title'
        t.input :description
        t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
        t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
        t.input :featured_image, :as => :file, hint: "#{t.object&.featured_image? ? t.object.featured_image_file_name : 'Recommended dimensions:'}"
        if t.object.featured_image.exists?
          fieldset do
            img class: 'inline-hints', src: t.object.image_s3_presigned_url, alt: t.object.image_alt_text, style: 'max-width:200px;'
          end
        end

        # Image preview
        # if t.object.featured_image.exists?
        #   div do
        #     img src: t.object.image_s3_presigned_url, alt: t.object.image_alt_text
        #     para "Current image name: #{t.object.featured_image_file_name}"
        #   end
        # end
        # if t.object.featured_image.exists?
        #   li do
        #     div class: 'page-image-preview-container no-padding' do
        #       div class: 'placeholder'
        #       div class: 'page-image-container' do
        #         img class: 'page-image', src: t.object.image_s3_presigned_url, alt: t.object.image_alt_text
        #         para "Current image name: #{t.object.featured_image_file_name}"
        #       end
        #     end
        #   end
        # end

        # # Checkbox for deleting the image
        if t.object.featured_image.exists?
          t.input :delete_image, as: :boolean, label: 'Delete image?'
        end
        t.input :image_alt_text, hint: 'Briefly describe this image for visually impaired users'

      end
    f.actions
  end

  # li class: 'file input required', id: "page_page_components_attributes_#{placeholder}_component_attributes_image_input" do
  #         label 'Image', for: "page_page_components_attributes_#{placeholder}_component_attributes_image", class: 'label'
  #         input value: component&.image_file_name || nil, type: 'file', required: 'required', accept: '.jpg, .jpeg, .png',
  #           id: "page_page_components_attributes_#{placeholder}_component_attributes_image",
  #           name: "page[page_components_attributes][#{placeholder}][component_attributes][image]"
  #         para 'File types allowed: jpg, png. Max file size: 25MB', class: 'inline-hints'
  #       end

  #       if component&.image.present?
  #         li do
  #           div class: 'page-image-preview-container no-padding' do
  #             div class: 'placeholder'
  #             div class: 'page-image-container' do
  #               img class: 'page-image', src: component.image_s3_presigned_url, alt: component.image_alt_text
  #               para "Current image name: #{component.image_file_name}"
  #             end
  #           end
  #         end
  #       end

  # # The following controller overrides is a brute force way of catching
  # # Paperclip::Errors::NotIdentifiedByImageMagickError's, which were being displayed to the
  # # user when submitting a corrupted image file, that our recent WASA report took issue with.
  # # The intention is to obscure the error while preserving active_admin's built-in error handling
  # # for anything other than a paperclip error.
  # controller do
  #   def create(_options={}, &block)
  #     create! do |success, failure|
  #       yield(success, failure) if block

  #       resource.errors.messages.each do |k,v|
  #         if v.include?("Paperclip::Errors::NotIdentifiedByImageMagickError")
  #           resource.errors.messages[k] = "There was an issue with uploading your image file."
  #         end
  #       end

  #       failure.html { render :new }
  #     end
  #   end

  #   def update(_options={}, &block)
  #     update! do |success, failure|
  #       yield(success, failure) if block

  #       resource.errors.messages.each do |k,v|
  #         if v.include?("Paperclip::Errors::NotIdentifiedByImageMagickError")
  #           resource.errors.messages[k] = "There was an issue with uploading your image file."
  #         end
  #       end

  #       failure.html { render :edit }
  #     end
  #   end
  # end
end
