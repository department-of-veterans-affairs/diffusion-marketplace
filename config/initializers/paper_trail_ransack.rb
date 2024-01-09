PaperTrail::Version.module_eval do
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "event", "id", "item_id", "item_type", "object", "object_changes", "whodunnit"]
  end
end
