class ClinicalResourceHub < ApplicationRecord
  # extend FriendlyId
  # friendly_id :name, use: :slugged
  belongs_to :visn
  has_many :diffusion_histories

  def to_param
    visn.number.to_s
  end
end