class Category < ApplicationRecord

  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'Category', optional: true
  acts_as_list

  has_many :category_practices, dependent: :destroy
  has_many :practices, through: :categories
  has_many :practices, through: :category_practices

  scope :with_practices,   -> { not_other.not_none.joins(:practices).where(practices: {approved: true, published: true, enabled: true} ).order_by_name.uniq }
  scope :order_by_name, -> { order(Arel.sql("lower(categories.name) ASC")) }
  scope :not_other, -> { where(is_other: false).where.not(name: 'Other').where.not(name: 'other') }
  scope :not_none, -> { where.not(name: 'None').where.not(name: 'none') }

  attr_accessor :related_terms_raw

  def self.get_clinical_category_id
    return Category.where(name: 'Clinical', is_other: false, parent_category_id: nil).first().id
  end

  def self.get_operational_category_id
    return Category.where(name: 'Operational', is_other: false, parent_category_id: nil).first().id
  end

  def self.get_strategic_category_id
    return Category.where(name: 'Strategic', is_other: false, parent_category_id: nil).first().id
  end


  def related_terms_raw
    self[:related_terms].join(", ") unless self[:related_terms].nil?
  end
end
