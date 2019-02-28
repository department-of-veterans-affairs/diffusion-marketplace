class PracticeManagement < ApplicationRecord
  acts_as_list
  has_many :practice_management_practices
  has_many :practices, through: :practice_management_practices
end
