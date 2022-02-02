class ClinicalResourceHub < ApplicationRecord
  belongs_to :visn
  has_many :diffusion_histories, dependent: :destroy
  has_many :practice_origin_facilities, dependent: :destroy

  def to_param
    visn.number.to_s
  end
end