class Product < Innovation
  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]

  # validates :main_display_image_alt_text, presence: true, if: :main_display_image_present?
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
  validates :name, presence: true
  validates_uniqueness_of :name, {message: 'Product name already exists'}

  after_update :update_date_published

  PRODUCT_EDITOR_NEXT_PAGE =
    {
      'description': 'intrapreneur',
      'intrapreneur': 'multimedia',
    }

  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def user_email
    user&.email
  end

  def remove_main_display_image(params)
    if params[:delete_main_display_image].present? && params[:delete_main_display_image] == 'true'
      self.update!(main_display_image: nil, main_display_image_alt_text: nil)
    else
      false
    end

    # Remove category practices that are not in the submitted category keys
    cat_practices_to_remove = product_category_practices.joins(:category).where.not(categories: { id: category_keys })
    if cat_practices_to_remove.any?
      cat_practices_to_remove.destroy_all
      changed = true
    end

    changed
  end

  def update_multimedia(multimedia_params)
    changed = false
    multimedia_resources = multimedia_params["practice_multimedia_attributes"]
    if multimedia_resources
      multimedia_resources.each do |r|
        if is_cropping?(r[1]) && r[1][:_destroy] == 'false' && r[1][:id].present?
          r_id = r[1][:id].to_i
          record = practice_multimedia.find(r_id)
          reprocess_attachment(record, r[1])
          changed = true
        end
      end
    end
    changed
  end

  private

  def main_display_image_present?
    main_display_image.present?
  end

  ransacker :user_email do
    Arel.sql("users.email")
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "user_email", "published"]
  end

  def update_date_published
    if saved_change_to_published?
      if published
        update_column(:date_published, Time.current)
      else
        update_column(:date_published, nil)
      end
    end
  end
end
