require 'rails_helper'
require_relative '../../../lib/paperclip_processors/cropper.rb'

module Paperclip
  RSpec.describe Cropper do
    before do

      @practice = Practice.new
      @practice.name = "Crop this image"
      @practice.tagline = "Cropping is so much fun."

    end

    describe '#transformation_command' do
      it 'returns the crop cmd when cropping?' do
        # attachment = File.read("#{Rails.root}/spec/assets/charmander.png")
        image_path = "#{Rails.root}/spec/assets/charmander.png"
        image_file = File.new(image_path)
        @practice.crop_x = 10
        @practice.crop_y = 10
        @practice.crop_w = 10
        @practice.crop_h = 10
        @practice.main_display_image = ActionDispatch::Http::UploadedFile.new(
            filename: File.basename(image_file),
            tempfile: image_file,
            # detect the image's mime type with MIME if you can't provide it yourself.
            type: MIME::Types.type_for(image_path).first.content_type
        )
        # cropper = Cropper.new(@practice.main_display_image)


        # expect
      end
    end
  end
end
