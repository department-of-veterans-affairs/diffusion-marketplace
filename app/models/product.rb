class Product < Innovation
  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]

  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
  validates :name, presence: true
  validates :name, uniqueness: {message: 'Product name already exists'}

  after_update :update_date_published

  attr_accessor :add_editor, :delete_editor

  PRODUCT_EDITOR_NEXT_PAGE =
    {
      'editors' => 'description',
      'description' => 'intrapreneur',
      'intrapreneur' => 'multimedia',
    }

  extend FriendlyId
  friendly_id :name, use: :slugged

  def user_email
    user&.email
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "user_email", "published"]
  end

  private

  def main_display_image_present?
    main_display_image.present?
  end

  ransacker :user_email do
    Arel.sql("users.email")
  end


  def update_date_published
    if saved_change_to_published?
      if published
        update(date_published: Time.current)
      else
        update(date_published: nil)
      end
    end
  end
end
