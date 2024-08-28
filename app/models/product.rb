class Product < Innovation
  has_attached_file :main_display_image, styles: {thumb: '768x432>'}, :processors => [:cropper]

  validates_uniqueness_of :name, {message: 'Innovation name already exists'}
  validates_attachment_content_type :main_display_image, content_type: /\Aimage\/.*\z/
end