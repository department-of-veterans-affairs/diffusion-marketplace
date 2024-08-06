ActiveAdmin.register Homepage do
  permit_params :internal_title, :section_title_one, :section_title_two, :section_title_three, homepage_feature_attributes: [:id, :title, :description, :url, :cta_text, :image, :image_alt_text, :section_id, :position, :_destroy]

 #  batch_action :destroy, false

 remove_filter :internal_title, :section_title_one, :section_title_two, :section_title_three, :homepage_features
 #  filter :title
 #  filter :description
 #  filter :url

  index do
    id_column
    column :internal_title
 #    # column :title
 # #    column :url
 # #    column :featured
 # #    actions do |topic|
 # #      topic_featured_action_str = topic.featured ? "Unfeature" : "Feature"
 # #      item topic_featured_action_str, feature_admin_topic_path(topic), method: :post
 # #    end
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

 #  show do
 #    attributes_table do
 #      row :id
 #      row :title
 #      row :description
 #      row :cta_text
 #      row :url
 #      row "Attachment" do
 #        if topic.attachment.present?
 #          div do
 #            image_tag(topic.attachment_s3_presigned_url(:thumb))
 #          end
 #        else
 #          div do
 #            "None"
 #          end
 #        end
 #      end
 #      row :featured
 #    end
 #  end

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
      f.input :internal_title, as: :string, required: true
    end
    f.inputs 'Section 1' do
      f.input :section_title_one
      f.has_many :homepage_features do |t|
        t.input :title
        t.input :description
        t.input :url
        t.input :cta_text
        # add image upload 
        # condition for image alt text
        # add something here to limit adding another if there are 3!
      end
    end

    f.inputs 'Section 2' do
      f.input :section_title_one
      f.has_many :homepage_features do |t|
        t.input :title
        t.input :description
        t.input :url
        t.input :cta_text
        # add image upload 
        # condition for image alt text
        # add something here to limit adding another if there are 3!
      end
    end

    f.inputs 'Section 3' do
      f.input :section_title_one
      f.has_many :homepage_features do |t|
        t.input :title
        t.input :description
        t.input :url
        t.input :cta_text
        # add image upload 
        # condition for image alt text
        # add something here to limit adding another if there are 3!
      end
    end

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

 #  # The following controller overrides is a brute force way of catching
 #  # Paperclip::Errors::NotIdentifiedByImageMagickError's, which were being displayed to the
 #  # user when submitting a corrupted image file, that our recent WASA report took issue with.
 #  # The intention is to obscure the error while preserving active_admin's built-in error handling
 #  # for anything other than a paperclip error.
 #  controller do
 #    def create(_options={}, &block)
 #      create! do |success, failure|
 #        yield(success, failure) if block

 #        resource.errors.messages.each do |k,v|
 #          if v.include?("Paperclip::Errors::NotIdentifiedByImageMagickError")
 #            resource.errors.messages[k] = "There was an issue with uploading your image file."
 #          end
 #        end

 #        failure.html { render :new }
 #      end
 #    end

 #    def update(_options={}, &block)
 #      update! do |success, failure|
 #        yield(success, failure) if block

 #        resource.errors.messages.each do |k,v|
 #          if v.include?("Paperclip::Errors::NotIdentifiedByImageMagickError")
 #            resource.errors.messages[k] = "There was an issue with uploading your image file."
 #          end
 #        end

 #        failure.html { render :edit }
 #      end
 #    end
 #  end
end
