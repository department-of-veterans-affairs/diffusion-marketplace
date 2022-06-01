require 'rails_helper'
include PracticeResourcesHelper

RSpec.describe PracticeResourcesHelper, type: :helper do
  describe 'resource_image_default_alt_text' do
    it 'should return default alt text based on the resource\'s class name and image\'s position' do
      new_problem_resource_image = PracticeMultimedium.create(name: 'test', position: 3)

      expect(resource_image_default_alt_text(new_problem_resource_image)).to eq('Multimedia image 3')
    end
  end
end