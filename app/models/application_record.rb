class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def signer
    @signer ||= Aws::S3::Presigner.new
  end

  def s3_presigned_url(path)
    signer.presigned_url(:get_object, bucket: ENV['S3_BUCKET_NAME'], key: path, expires_in: 86400 ) # number of seconds in a day
  end

  def object_presigned_url(obj, style = nil)
    if Rails.env.test?
      obj.url
    else
      # this presumes the object path is s3 ready that has a beginning forward slash
      # need to take out first `/` from the path, `.sub` takes care of that
      path = obj.path(style).sub('/', '')
      s3_presigned_url(path)
    end
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
