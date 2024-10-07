class Innovation < ApplicationRecord
  self.abstract_class = true
  has_paper_trail

  belongs_to :user, optional: true
  has_many :category_practices, as: :innovable, dependent: :destroy, autosave: true
  has_many :categories, through: :category_practices
  has_many :va_employee_practices, as: :innovable, dependent: :destroy
  has_many :va_employees, -> { order(position: :asc) }, through: :va_employee_practices
  has_many :practice_multimedia, -> { order(id: :asc) }, as: :innovable, dependent: :destroy
  has_many :practice_partner_practices, as: :innovable, dependent: :destroy
  has_many :practice_partners, through: :practice_partner_practices

  accepts_nested_attributes_for :va_employees, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? || attributes['role'].blank? }
  accepts_nested_attributes_for :practice_multimedia, allow_destroy: true

  scope :published,   -> { where(published: true) }
  scope :unpublished,  -> { where(published: false) }

  attr_accessor :delete_main_display_image
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def main_display_image_s3_presigned_url(style = nil)
    object_presigned_url(main_display_image, style)
  end
end
