require 'rails_helper'
require_relative '../../../lib/paperclip_processors/cropper.rb'

module Paperclip
  RSpec.describe Cropper do
    before do
      @practice = Practice.new
      @practice.name = "Crop this image"
      @practice.tagline = "Cropping is so much fun."
      image_path = "#{Rails.root}/spec/assets/charmander.png"
      @image_file = File.new(image_path)
    end

    describe 'when cropping?' do
      it 'returns the crop cmd' do
        @practice.crop_x = 10
        @practice.crop_y = 10
        @practice.crop_w = 10
        @practice.crop_h = 10

        cropper = Cropper.new(@image_file, {}, @practice.main_display_image)

        expect(cropper.cropping?).to eq true
        expect(cropper.transformation_command).to eq ["-crop", "10.0x10.0+10.0+10.0", "+repage", "-auto-orient"]
      end
    end

    describe 'when not cropping?' do
      it 'does not return the crop cmd' do
        @practice.crop_x = 10
        @practice.crop_y = 10
        @practice.crop_w = nil
        @practice.crop_h = nil

        cropper = Cropper.new(@image_file, {}, @practice.main_display_image)

        expect(cropper.cropping?).to eq false
        expect(cropper.transformation_command).to eq ["-auto-orient"]
      end
    end
  end
end
