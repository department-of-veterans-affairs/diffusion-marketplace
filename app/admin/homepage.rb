ActiveAdmin.register Homepage do
  permit_params :internal_title, :section_title_one, :section_title_two, :section_title_three, :published, homepage_features_attributes: [:id, :title, :description, :url, :cta_text, :featured_image, :featured_image_file_name, :featured_image_content_type, :featured_image_updated_at, :featured_image_file_size, :image_alt_text, :delete_image, :section_id, :homepage_id, :position, :_destroy]


  config.filters = false
  config.sort_order = 'published_asc'

  # Customizing the action items (buttons) on the show page
  action_item :publish, priority: 0, only: :show do
    publish_action_str = resource.published? ? 'Unpublish' : 'Publish'
    link_to publish_action_str, publish_admin_homepage_path(resource), method: :post
  end

  member_action :publish, priority: 0, method: :post do
    already_published = Homepage.where(published: true)
    if resource.published
      message = "\"#{resource.internal_title.to_s}\" unpublished"
      resource.published = false
    else
      message = "\"#{resource.internal_title.to_s}\" published, \"#{already_published.pluck(:internal_title).join(',')}\" unpublished "
      already_published.update_all(published: false)
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

    panel "Section 1: #{homepage&.section_title_one}" do
      table_for homepage.homepage_features.where(section_id: 1) do
        column :section_id
        column :title
        column :featured_image_file_name
        column :description
        column :url
        column :cta_text
      end
    end
    panel "Section 2: #{homepage&.section_title_two}" do
      table_for homepage.homepage_features.where(section_id: 2) do
        column :section_id
        column :title
        column :featured_image_file_name
        column :description
        column :url
        column :cta_text
      end
    end
    panel "Section 3: #{homepage&.section_title_three}" do
      table_for homepage.homepage_features.where(section_id: 3) do
        column :section_id
        column :title
        column :featured_image_file_name
        column :description
        column :url
        column :cta_text
      end
    end
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Nickname' do
      f.input :internal_title, as: :string,
        required: true,
        hint: 'e.g. September 2024 homepage'
    end
    f.inputs 'Section 1' do
      f.input :section_title_one, label: 'Section 1 Title', hint: 'e.g. Featured Innovations'
    end

    f.inputs 'Section 2' do
      f.input :section_title_two, label: 'Section 2 Title', hint: 'e.g. Trending Tags'
    end

    f.inputs 'Section 3' do
      f.input :section_title_three, label: 'Section 3 Title', hint: 'e.g. Innovation Communities'
    end

    f.has_many :homepage_features, heading: "Features", new_record: 'Add Feature', allow_destroy: true do |t|
      # f.has_many :homepage_features, new_record: 'Add Feature', allow_destroy: true, sortable: :position, sortable_start: 1 do |t|
        t.input :section_id, as: :select, collection: [1,2,3], label: 'Section', hint: "Maximum of 3 features per section"
        t.input :title, label: 'Feature Title'
        t.input :description
        t.input :url, label: 'Call to Action URL', hint: 'e.g. /about or https://va.gov'
        t.input :cta_text, label: 'Call to Action Text', hint: 'e.g. View Innovation, Register Now'
        t.input :featured_image,
          as: :file,
          hint: (
            if t.object.featured_image.exists?
              image_tag(
                t.object.image_s3_presigned_url,
                alt: t.object.image_alt_text,
                style: 'max-width: 400px; display: block;object-fit:cover;aspect-ratio:4/3;'
              ) +
              content_tag(:span, "Current image name: #{t.object.featured_image_file_name}")
            else
              'Recommended dimensions:'
            end
          )

        # Checkbox for deleting the image
        if t.object.featured_image.exists?
          t.input :delete_image, as: :boolean, label: 'Delete image?'
        end
        t.input :image_alt_text, hint: 'Briefly describe this image for visually impaired users'

      end
    f.actions
  end

  # # The following controller overrides is a brute force way of catching
  # # Paperclip::Errors::NotIdentifiedByImageMagickError's, which were being displayed to the
  # # user when submitting a corrupted image file, that our recent WASA report took issue with.
  # # The intention is to obscure the error while preserving active_admin's built-in error handling
  # # for anything other than a paperclip error.
  controller do
    def create(_options={}, &block)
      create! do |success, failure|
        yield(success, failure) if block

        resource.errors.messages.each do |k,v|
          if v.include?("Paperclip::Errors::NotIdentifiedByImageMagickError")
            resource.errors.messages[k] = "There was an issue with uploading your image file."
          end
        end

        failure.html { render :new }
      end
    end

    def update(_options={}, &block)
      update! do |success, failure|
        yield(success, failure) if block

        resource.errors.messages.each do |k,v|
          if v.include?("Paperclip::Errors::NotIdentifiedByImageMagickError")
            resource.errors.messages[k] = "There was an issue with uploading your image file."
          end
        end

        failure.html { render :edit }
      end
    end

    def destroy(_options={}, &block)
      if resource.published?
        message = "Homepage must be unpublished before deleting"
        redirect_back fallback_location: admin_homepages_path, flash: { error: message }
      else
        super
      end
    end
  end
end
