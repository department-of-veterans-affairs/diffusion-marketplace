require 'rails_helper'

RSpec.describe DiffusionHistoryStatus, type: :model do
  it { should belong_to(:diffusion_history) }
end
