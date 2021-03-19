class Visn < ApplicationRecord
  has_many :vamcs, dependent: :destroy
  has_many :visn_liaisons, dependent: :destroy

  # Add a custom friendly URL that uses the visn number and not the id
  def to_param
    number.to_s
  end
end