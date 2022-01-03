class Category < ApplicationRecord

  before_validation :trim_whitespace
  before_save :clear_categories_cache_on_save
  after_save :reset_categories_cache

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
  scope :get_category_by_name, -> (cat_name) { where('lower(name) = ?', cat_name.downcase).where(is_other: false) }
  scope :get_category_names, -> { not_other.not_none.pluck(:name) }

  attr_accessor :related_terms_raw
  attr_accessor :reset_cached_categories

  def related_terms_raw
    self[:related_terms].join(", ") unless self[:related_terms].nil?
  end

  def trim_whitespace
    self.name&.strip!
  end

  def self.get_parent_categories
    Category.order_by_name.select { |cat| cat.is_other === false && cat.sub_categories.any? }
  end

  def clear_categories_cache
    Rails.cache.delete('categories')
  end

  def reset_categories_cache
    clear_categories_cache if self.reset_cached_categories
  end

  def clear_categories_cache_on_save
    if self.changed?
      self.reset_cached_categories = true
    end
  end

  def self.cached_categories
    Rails.cache.fetch('categories') do
      Category.where(is_other: false).joins(:parent_category).where.not(parent_category: nil).order_by_name.includes(:parent_category)
    end
  end

  def self.get_cached_categories_grouped_by_parent
    cached_categories.group_by(&:parent_category)
  end
end
