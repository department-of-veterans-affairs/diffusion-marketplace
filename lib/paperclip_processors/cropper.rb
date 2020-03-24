# Reference: http://railscasts.com/episodes/182-cropping-images
module Paperclip
  class Cropper < Thumbnail
    def target
      @attachment.instance
    end

    # checks if all crop values are present on the attachment
    def cropping?
      target.crop_w.present? && target.crop_h.present? && target.crop_x.present? && target.crop_y.present?
    end

    def transformation_command
      # if not cropping, returns default ImageMagick cmd
      # see: https://github.com/thoughtbot/paperclip#post-processing
      return super unless cropping?
      crop_command = [
        "-crop",
        "#{target.crop_w.to_f}x" \
        "#{target.crop_h.to_f}+" \
        "#{target.crop_x.to_f}+" \
        "#{target.crop_y.to_f}",
        "+repage"
      ]
      # if cropping, an additonal ImageMagick geometry option is added to the default post-processing cmd
      # http://www.imagemagick.org/script/command-line-options.php#crop
      crop_command + super
    end
  end
end
