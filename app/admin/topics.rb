ActiveAdmin.register Topic do
  permit_params :title, :description, :url, :cta_text, :attachment, :featured

  batch_action :destroy, false

  filter :title
  filter :description
  filter :url

  index do
    id_column
    column :title
    column :url
    column :featured
    actions do |topic|
      topic_featured_action_str = topic.featured ? "Unfeature" : "Feature"
      item topic_featured_action_str, feature_admin_topic_path(topic), method: :post
    end
  end

  member_action :feature, method: :post do
    resource.featured = !resource.featured
    message = "Topic with ID #{resource.id} is now featured."
    if resource.featured
      other_topics = Topic.where.not(id: resource.id)
      if other_topics.present?
        other_topics.each do |other_topic|
          other_topic.update_attributes(featured: false)
        end
      end
    else
      message = "Topic with ID #{resource.id} is now unfeatured."
    end
    resource.save
    redirect_back fallback_location: root_path, notice: message
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :cta_text
      row :url
      row "Attachment" do
        if topic.attachment.present?
          div do
            image_tag(topic.attachment_s3_presigned_url(:thumb))
          end
        else
          div do
            "None"
          end
        end
      end
      row :featured
    end
  end

 form do |f|
    f.inputs do
      f.input :title, as: :string, required: true
      f.input :description, as: :string, required: true
      f.input :url, label: "Call to action URL", as: :string, hint: "Can be an internal (e.g. /partners) or external (e.g. https://www.va.gov) URL", required: true
      f.input :cta_text, label: "Call to action text", as: :string, required: true
      f.input :attachment, :as => :file, required: true
      if topic.attachment.exists?
        div '', style: 'width: 20%', class: 'display-inline-block'
          div class: 'display-inline-block' do
            image_tag(topic.attachment_s3_presigned_url(:thumb))
          end
        end
      end
    f.actions
  end
end
