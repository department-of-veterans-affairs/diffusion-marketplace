class Homepage < ApplicationRecord
  has_many :homepage_features, dependent: :destroy
  accepts_nested_attributes_for :homepage_features, allow_destroy: true

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    []
  end
end
