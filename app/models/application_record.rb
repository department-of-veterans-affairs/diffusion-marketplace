class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def signer
    @signer ||= Aws::S3::Presigner.new
  end

  def s3_presigned_url(path)
    signer.presigned_url(:get_object, bucket: ENV['S3_BUCKET_NAME'], key: path )
  end

  # this presumes the object path is s3 ready that has a beginning forward slash
  def object_presigned_url(obj, style = nil)
    # need to take out first `/` from the path, `.sub` takes care of that
    path = obj.path(style).sub('/', '')
    s3_presigned_url(path)
  end
end
