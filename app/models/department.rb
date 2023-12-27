class Department < ApplicationRecord
  acts_as_list
  has_paper_trail
  has_many :department_practices
  has_many :practices, through: :department_practices

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "position", "short_name", "updated_at"]
  end
end
