class Product < Innovation
  include CropperUtils
  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]

  validates :main_display_image_alt_text, presence: true, if: :main_display_image_present?
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
  validates :name, presence: true
  validates_uniqueness_of :name, {message: 'Product name already exists'}

  after_update :update_date_published

  PRODUCT_EDITOR_SLUGS =
    {
      'description': 'intrapreneur',
      'intrapreneur': 'multimedia',
    }

  extend FriendlyId
  friendly_id :name, use: :slugged

  def user_email
    user&.email
  end

  def update_category_practices(category_params)
    changed = false

    category_keys = category_params ? category_params.keys.map { |key| key.gsub("_resource", "") } : []
    current_category_ids = categories.pluck(:id)
    product_category_practices = category_practices

    # Add new category practices if not present
    missing_category_ids = category_keys.map(&:to_i) - current_category_ids
    missing_category_ids.delete(0) if missing_category_ids.count
    if missing_category_ids.any?
      missing_category_ids.each do |category_id|
        product_category_practices.create!(category_id: category_id)
      end
      changed = true
    end

    # Remove category practices that are not in the submitted category keys
    practices_to_remove = product_category_practices.joins(:category).where.not(categories: { id: category_keys })
    if practices_to_remove.any?
      practices_to_remove.destroy_all
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
