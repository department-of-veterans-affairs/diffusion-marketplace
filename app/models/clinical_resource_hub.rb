class ClinicalResourceHub < ApplicationRecord
  belongs_to :visn
  has_many :diffusion_histories

  def to_param
    visn.number.to_s
  end
end