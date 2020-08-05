class PracticeMultimedia < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end
end