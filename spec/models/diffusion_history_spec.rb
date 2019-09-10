require 'rails_helper'

RSpec.describe DiffusionHistory, type: :model do
  it { should belong_to(:practice) }
  it { should have_many(:diffusion_history_statuses) }
end
