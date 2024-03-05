class Topic < ApplicationRecord
  has_attached_file :attachment, styles: {thumb: '768x432>'} # TODO: modify thumb size
  validates :title, :description, :url, :cta_text, presence: true
  validates_attachment :attachment,
                       presence: { message: "can't be blank" },
                       content_type: {
                         content_type: %w[image/jpg image/jpeg image/png],
                         message: "must be one of the following types: jpg, jpeg, or png"
                       }
  validates_with InternalUrlValidator, on: [:create, :update], if: Proc.new { |topic| topic.url.present? && topic.url.chars.first === '/' }
  validates_with ExternalUrlValidator, on: [:create, :update], if: Proc.new { |topic| topic.url.present? && topic.url.chars.first != '/' }

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "description", "url"]
  end
end
