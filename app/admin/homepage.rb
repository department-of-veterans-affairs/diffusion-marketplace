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

    panel resource.section_title_one do
      # scope this to just this section
      table_for homepage.homepage_features do
        column :title
        column :description
        column :url
        column :cta_text
        # image preview
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
      byebug
      f.input :section_title_one, required: true, label: 'Section Title', hint: 'e.g. Featured Innovations'
      f.has_many :homepage_features, collection: HomepageFeature.where(section_id: 1, homepage_id: f.object.id), new_record: 'Add Feature', allow_destroy: true do |t|
        current_section = 1
        # Filter to only include HomepageFeatures with section_id: 1
        t.object = f.object.homepage_features.where(section_id: 1).find_by(id: t.object.id) || HomepageFeature.new
        t.input :title, label: 'Feature Title'
        t.input :description
        t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
        t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
        t.input :featured_image, :as => :file
        # Image preview
        # if t.object.featured_image.exists?
        #   div do
        #   img src: t.object.image_s3_presigned_url, alt: t.object.image_alt_text
        #   para "Current image name: #{t.object.featured_image_file_name}"
        # end
        # end
        # Checkbox for deleting the image
        if t.object.featured_image.exists?
          t.input :delete_image, as: :boolean, label: 'Delete image?'
        end
        t.input :image_alt_text, hint: 'Briefly describe this image for visually impaired users'
        
        # 
        # Pre-populate 'feature_name' with a default value if it's a new record or empty
        if t.object.any_fields_filled?
          t.input :section_id, label: 'Section ID', input_html: { value: current_section }, as: :hidden
        else
          t.input :section_id, label: 'Section ID', input_html: { value: nil }, as: :hidden
          # t.object.section_id = nil
        end
      end
    end

    f.inputs 'Section 2' do
      f.input :section_title_two, required: true, label: 'Section Title', hint: 'e.g. Trending Tags'
      f.has_many :homepage_features, collection: HomepageFeature.where(section_id: 2, homepage_id: f.object.id), new_record: 'Add Feature', allow_destroy: true do |t|
        current_section = 2
        # Filter to only include HomepageFeatures with section_id: 2
        t.object = f.object.homepage_features.where(section_id: 2).find_by(id: t.object.id)
        t.input :title, label: 'Feature Title'
        t.input :description
        t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
        t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
        t.input :featured_image, :as => :file
        # # Image preview
        # if t.object.featured_image.exists?
        #   img class: 'page-image', src: t.object.image_s3_presigned_url, alt: t.object.image_alt_text
        #   para "Current image name: #{t.object.featured_image_file_name}"
        # end
        # Checkbox for deleting the image
        if t.object.featured_image.exists?
          t.input :delete_image, as: :boolean, label: 'Delete image?'
        end
        t.input :image_alt_text, hint: 'Briefly describe this image for visually impaired users'
        
        # Pre-populate 'feature_name' with a default value if it's a new record or empty
        # default_section_id = t.object.section_id.present? ? t.object.section_id : 2
        # t.input :section_id, label: 'Section ID', input_html: { value: default_section_id }, as: :hidden
        # byebug
        if t.object.any_fields_filled?
          t.input :section_id, label: 'Section ID', input_html: { value: current_section }, as: :hidden
        else
          t.object.section_id = nil
        end
      end
    end

    # f.inputs 'Section 3' do
      # f.input :section_title_three, required: true, label: 'Section Title', hint: 'e.g. Innovation Communities'
      # f.has_many :homepage_features, new_record: 'Add Feature' do |t|
      #   # Filter to only include HomepageFeatures with section_id: 3
      #   t.object = f.object.homepage_features.where(section_id: 3).find_by(id: t.object.id) || HomepageFeature.new
      #   t.input :title, label: 'Feature Title'
      #   t.input :description
      #   t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
      #   t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
      #   t.input :featured_image, :as => :file
      #   # # Image preview
      #   # if t.object.featured_image.exists?
      #   #   img class: 'page-image', src: t.object.image_s3_presigned_url, alt: t.object.image_alt_text
      #   #   para "Current image name: #{t.object.featured_image_file_name}"
      #   # end
      #   # Checkbox for deleting the image
      #   if t.object.featured_image.exists?
      #     t.input :delete_image, as: :boolean, label: 'Delete image?'
      #   end
      #   t.input :image_alt_text, hint: 'Briefly describe this image for visually impaired users'
        
      #   # Pre-populate 'feature_name' with a default value if it's a new record or empty
      #   default_section_id = t.object.section_id.present? ? t.object.section_id : 3
      #   t.input :section_id, label: 'Section ID', input_html: { value: default_section_id }, as: :hidden
      # end
    # end

    # f.inputs 'Features' do
    #   # f.has_many :homepage_features, heading: false, sortable: :position, sortable_start: 1 do |t|
    #   f.has_many :homepage_features do |t|
    #     t.input :title
    #     t.input :description
    #     t.input :url
    #     t.input :cta_text
    #     # new_record: 'Leave Comment',
    #              # remove_record: 'Remove Comment'
    #     #          allow_destroy: -> (c) { c.author?(current_admin_user) } do |b|
    #     # end
    #   end
    # end
    # f.inputs 'Comments' do
    #   f.has_many :comments,
    #              heading: false,
    #              new_record: 'Leave Comment',
    #              remove_record: 'Remove Comment',
    #              allow_destroy: -> (c) { c.author?(current_admin_user) } do |b|
    #     b.input :body
    #   end
    # end
    f.actions
  end

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
