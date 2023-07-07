class PagePublicationComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  has_attached_file :attachment, :default_url => ""
  do_not_validate_attachment_file_type :attachment
  validates :title, presence: true

  validates_with InternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end
end
