require 'rails_helper'

RSpec.describe PageDownloadableFileComponent, type: :model do
  describe 'associations' do
    it { should have_one(:page_component) }
  end
end
