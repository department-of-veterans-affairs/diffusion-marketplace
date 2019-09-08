class DiffusionHistory < ApplicationRecord
  belongs_to :practice
  has_many :diffusion_history_statuses
end
