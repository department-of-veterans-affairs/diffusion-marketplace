class HomepageFeature < ApplicationRecord
  belongs_to :homepage
  has_attached_file :feature_image

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    []
  end
end