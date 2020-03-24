require 'rails_helper'
require_relative '../../../lib/paperclip_processors/cropper.rb'

module Paperclip
  RSpec.describe Cropper do

    describe '#transformation_command' do
      it 'returns the crop cmd when cropping?' do
        attachment = File.read("#{Rails.root}/spec/assets/charmander.png")
        cropper = Cropper.new(attachment)

        # expect
      end
    end
  end
end
