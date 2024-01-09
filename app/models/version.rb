class Version < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["item_type", "item_id", "event", "whodunnit", "object", "object_changes", "created_at"]
  end
end
