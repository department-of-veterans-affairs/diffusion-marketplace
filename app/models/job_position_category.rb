class JobPositionCategory < ApplicationRecord
  acts_as_list
  has_many :job_positions
  has_many :sub_impact_categories, class_name: 'JobPositionCategory', foreign_key: 'parent_category_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'JobPositionCategory'
end
