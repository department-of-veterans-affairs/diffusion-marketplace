class DiffusionHistoryStatus < ApplicationRecord
  belongs_to :diffusion_history

  # status strings are In Progress/Complete/Unsuccessful
end
