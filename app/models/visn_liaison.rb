class VisnLiaison < ApplicationRecord
  belongs_to :visn

  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "email",]
  end
end
