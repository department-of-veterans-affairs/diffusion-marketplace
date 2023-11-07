require 'rails_helper'

RSpec.describe PageSimpleButtonComponent, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:button_text) }
    it { should validate_presence_of(:url) }
  end

  describe 'associations' do
    it { should have_one(:page_component) }
  end
end
