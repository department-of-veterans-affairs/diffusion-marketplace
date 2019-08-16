require 'rails_helper'

RSpec.describe JobPosition, type: :model do
  describe 'associations' do
    it { should belong_to(:job_position_category).optional  }
    it { should have_many(:job_position_practices) }
    it { should have_many(:practices) }
  end
end
