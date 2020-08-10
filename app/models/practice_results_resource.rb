class PracticeResultsResource < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
  enum resource_type: {image: 0, video: 1, file: 2, link: 3}

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end
end