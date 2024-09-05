class Product < Innovation
  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]
  validates :main_display_image_alt_text, presence: true, if: :main_display_image_present?

  validates_uniqueness_of :name, {message: 'Product name already exists'}
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/

  private

  def main_display_image_present?
    main_display_image.present?
  end
end