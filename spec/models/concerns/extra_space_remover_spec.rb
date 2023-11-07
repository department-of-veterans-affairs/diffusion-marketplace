require 'rails_helper'

include ExtraSpaceRemover

RSpec.describe ExtraSpaceRemover do
  describe 'strip_attributes' do
    it 'should remove white space from the beginning and end of string attributes' do
      practice = Practice.new(name: '    hello world ', main_display_image_alt_text: 'test    ')
      strip_attributes([practice.name, practice.main_display_image_alt_text])
      expect(practice.name).to eq('hello world')
      expect(practice.main_display_image_alt_text).to eq('test')
    end
  end
end