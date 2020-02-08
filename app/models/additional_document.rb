class AdditionalDocument < ApplicationRecord
  acts_as_list scope: :practice
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
  belongs_to :practice
  # validates :title, presence: true

  attr_accessor :delete_attachment

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end
end
