require 'rails_helper'

RSpec.describe JobPositionCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:parent_category) }
    it { should have_many(:sub_job_position_categories) }
    it { should have_many(:job_positions) }
  end
end
