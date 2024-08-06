ActiveAdmin.register Homepage do
  permit_params :internal_title, :section_title_one, :section_title_two, :section_title_three, :published, homepage_features_attributes: [:id, :title, :description, :url, :cta_text, :image, :image_alt_text, :section_id, :position, :_destroy]


  config.filters = false
  config.sort_order = 'published_asc'

  # Custom action to publish a homepage
  member_action :publish, method: :post do
    currently_published = resource.published?
    resource.update(published: !currently_published)
    redirect_to resource_path, notice: "Homepage has been published."
  end

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

  index do
    id_column
    column :internal_title
    column :published
    column :updated_at
 # #    actions do |topic|
 # #      topic_featured_action_str = topic.featured ? "Unfeature" : "Feature"
 # #      item topic_featured_action_str, feature_admin_topic_path(topic), method: :post
 # #    end
    # actions do |homepage|
    #   publish_action_str = resource.published? ? 'Unpublish' : 'Publish'
    #   link_to publish_action_str, publish_admin_homepage_path(resource), method: :post
    # end
    actions
  end

 #  member_action :feature, method: :post do
 #    resource.featured = !resource.featured
 #    message = "Topic with ID #{resource.id} is now featured."
 #    if resource.featured
 #      other_topics = Topic.where.not(id: resource.id)
 #      if other_topics.present?
 #        other_topics.each do |other_topic|
 #          other_topic.update(featured: false)
 #        end
 #      end
 #    else
 #      message = "Topic with ID #{resource.id} is now unfeatured."
 #    end
 #    resource.save
 #    redirect_back fallback_location: root_path, notice: message
 #  end

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
    f.inputs 'Nickname' do
      f.input :internal_title, as: :string, 
        required: true, 
        hint: 'e.g. September 2024 homepage'
    end
    f.inputs 'Section 1' do
      f.input :section_title_one, required: true, label: 'Section Title', hint: 'e.g. Featured Innovations'
      f.has_many :homepage_features, new_record: 'Add Feature' do |t|
        t.input :title, label: 'Feature Title'
        t.input :description
        t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
        t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
        t.input :feature_image, :as => :file
      # if topic.attachment.exists?
      #   div '', style: 'width: 20%', class: 'display-inline-block'
      #     div class: 'display-inline-block' do
      #       image_tag(topic.attachment_s3_presigned_url(:thumb))
      #     end
      #   end
      # end
        # condition for image alt text
        t.input :image_alt_text
        # add something here to limit adding another if there are 3!
      end
    end

    # f.inputs 'Section 2' do
    #   f.input :section_title_two, required: true, label: 'Section Title', hint: 'e.g. Trending Tags'
    #   f.has_many :homepage_features, new_record: 'Add Feature' do |t|
    #     t.input :title, label: 'Feature Title'
    #     t.input :description
    #     t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
    #     t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
    #     # add image upload 
    #     # condition for image alt text
    #     # add something here to limit adding another if there are 3!
    #   end
    # end

    # f.inputs 'Section 3' do
    #   f.input :section_title_three, required: true, label: 'Section Title', hint: 'e.g. Innovation Communities'
    #   f.has_many :homepage_features, new_record: 'Add Feature' do |t|
    #     t.input :title, label: 'Feature Title'
    #     t.input :description
    #     t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
    #     t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
    #     # add image upload 
    #     # condition for image alt text
    #     # add something here to limit adding another if there are 3!
    #   end
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
