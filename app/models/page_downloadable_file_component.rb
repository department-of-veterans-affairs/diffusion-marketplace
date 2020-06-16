class PageDownloadableFileComponent < ApplicationRecord
  has_attached_file :attachment, :default_url => ""
  do_not_validate_attachment_file_type :attachment
  validates :attachment, attachment_presence: true
  has_one :page_component, as: :component, autosave: true

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end
end
