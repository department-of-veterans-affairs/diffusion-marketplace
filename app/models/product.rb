class Product < Innovation
  has_many :va_employee_practices, as: :innovable, dependent: :destroy
  has_many :va_employees, -> { order(position: :asc) }, through: :va_employee_practices

  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]
  validates :main_display_image_alt_text, presence: true, if: :main_display_image_present?
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/

  validates_uniqueness_of :name, {message: 'Product name already exists'}

  private

  def main_display_image_present?
    main_display_image.present?
  end
end