class PracticeProblemResource < ApplicationRecord
  acts_as_list scope: :practice
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
  belongs_to :practice

  enum resource_type: {image: 0, video: 1, file: 2, link: 3}

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end
end