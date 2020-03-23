# Reference: http://railscasts.com/episodes/182-cropping-images
module Paperclip
  class Cropper < Thumbnail
    def target
      @attachment.instance
    end

    def cropping?
      target.crop_w.present? && target.crop_h.present? && target.crop_x.present? && target.crop_y.present?
    end

    def transformation_command
      return super unless cropping?
      crop_command = [
        "-crop",
        "#{target.crop_w.to_f}x" \
        "#{target.crop_h.to_f}+" \
        "#{target.crop_x.to_f}+" \
        "#{target.crop_y.to_f}",
        "+repage"
      ]
      crop_command + super
    end
  end
end
