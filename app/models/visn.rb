class Visn < ApplicationRecord
  has_many :va_facilities, dependent: :destroy

  # Add a custom friendly URL that uses the visn number and not the id
  def to_param
    number.to_s
  end
end