class VisnLiaison < ApplicationRecord
  belongs_to :visn

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "first_name", "id", "last_name", "primary", "updated_at", "visn_id"]
  end
end