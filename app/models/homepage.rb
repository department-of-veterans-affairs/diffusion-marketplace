class Homepage < ApplicationRecord
  has_many :homepage_features, dependent: :destroy
  
  def self.ransackable_attributes(auth_object = nil)
    []
  end
end