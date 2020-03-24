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

        cropper = Cropper.new(image_file, {}, @practice.main_display_image)

        # expect
      end
    end
  end
end
