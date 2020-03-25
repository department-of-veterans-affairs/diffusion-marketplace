class VaEmployee < ApplicationRecord
  acts_as_list
  has_paper_trail
  has_attached_file :avatar, styles: { thumb: '200x200#' }
  do_not_validate_attachment_file_type :avatar

  has_many :va_employee_practices
  has_many :practices, through: :va_employee_practices

  attr_accessor :delete_avatar

  def avatar_s3_presigned_url(style = nil)
    object_presigned_url(avatar, style)
  end
end
