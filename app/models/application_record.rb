class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def signer
    s3_bucket = Aws::S3::Bucket.new(ENV['S3_BUCKET_NAME'])
    @signer ||= WT::S3Signer.for_s3_bucket(s3_bucket, expires_in: 84000)
  end

  def s3_presigned_url(path)
    signer.presigned_get_url(object_key: path)
  end

  def object_presigned_url(obj)
      obj.url
  end

  def process_avatar_crop(crop_options)
    # using `self` here to circumvent future rubocop offenses
    if crop_options[:crop_w].present? && crop_options[:crop_h].present? && crop_options[:crop_x].present? && crop_options[:crop_y].present? && self.avatar.present?
      self.crop_x = crop_x
      self.crop_y = crop_y
      self.crop_w = crop_w
      self.crop_h = crop_h
      self.avatar.reprocess!
    end
  end

  def process_attachment_crop(crop_options)
    # using `self` here to circumvent future rubocop offenses
    if crop_options[:crop_w].present? && crop_options[:crop_h].present? && crop_options[:crop_x].present? && crop_options[:crop_y].present? && self.attachment.present?
      self.crop_x = crop_x
      self.crop_y = crop_y
      self.crop_w = crop_w
      self.crop_h = crop_h
      self.attachment.reprocess!
    end
  end
end
