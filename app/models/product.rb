class Product < Innovation
  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]

  validates :main_display_image_alt_text, presence: true, if: :main_display_image_present?
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
  validates :name, presence: true
  validates_uniqueness_of :name, {message: 'Product name already exists'}

  after_update :update_date_published

  extend FriendlyId
  friendly_id :name, use: :slugged

  def user_email
    user&.email
  end

  def update_category_practices(category_params)
    category_keys = category_params ? category_params.keys.map { |key| key.gsub("_resource", "") } : []
    current_category_ids = categories.pluck(:id)
    product_category_practices = category_practices

    # Add new category practices if not present
    (category_keys.map(&:to_i) - current_category_ids).each do |category_id|
      product_category_practices.find_or_create_by(category_id: category_id)
    end

    # Remove category practices that are not in the submitted category keys
    product_category_practices.joins(:category).where.not(categories: { id: category_keys }).destroy_all
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
