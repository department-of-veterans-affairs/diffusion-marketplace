class Category < ApplicationRecord
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'Category', optional: true
  acts_as_list

  has_many :category_practices
  has_many :practices, through: :categories

  attr_accessor :related_terms_raw

  def related_terms_raw
    self[:related_terms].join(", ") unless self[:related_terms].nil?
  end
end
