class ImpactCategory < ApplicationRecord
  acts_as_list
  has_many :impacts
  has_many :sub_impact_categories, class_name: 'ImpactCategory', foreign_key: 'parent_category_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'ImpactCategory'
end
