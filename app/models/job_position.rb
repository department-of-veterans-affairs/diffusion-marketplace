class JobPosition < ApplicationRecord
  acts_as_list
  belongs_to :job_position_category, optional: true
  has_many :practices, through: :job_position_practices
end
