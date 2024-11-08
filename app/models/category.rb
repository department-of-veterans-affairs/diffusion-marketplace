class Category < ApplicationRecord
  include ExtraSpaceRemover

  before_validation :trim_whitespace
  after_commit :clear_caches

  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'Category', optional: true
  acts_as_list

  has_many :category_practices, dependent: :destroy
  has_many :innovable_practices, through: :category_practices, source: :innovable, source_type: 'Practice'
  has_many :innovable_products, through: :category_practices, source: :innovable, source_type: 'Product'

  scope :with_practices,   -> { not_none.joins(:innovable_practices).where(practices: {approved: true, published: true, enabled: true} ).order_by_name.uniq }
  scope :order_by_name, -> { order(Arel.sql("lower(categories.name) ASC")) }
  scope :not_none, -> { where.not('LOWER(categories.name) = ?', 'none') }
  scope :get_category_by_name, -> (cat_name) { where('lower(name) = ?', cat_name.downcase) }
  scope :get_category_names, -> { not_none.order(:name).pluck(:name) }

  attr_accessor :related_terms_raw
  attr_accessor :reset_cached_categories

  def related_terms_raw
    self[:related_terms].join(", ") unless self[:related_terms].nil?
  end

  def trim_whitespace
    strip_attributes([self.name])
  end

  def self.get_parent_categories
    Category.includes([:sub_categories]).order_by_name.select do |cat|
      cat.sub_categories.any?
    end
  end

  def self.cached_categories
    Rails.cache.fetch('categories') do
      Category.joins(:parent_category).where.not(parent_category: nil).order_by_name.includes(:parent_category).load
    end
  end

  def self.get_cached_categories_grouped_by_parent
    sub_categories = cached_categories.where.not(parent_category_id: nil).includes(:parent_category)
    grouped_categories = sub_categories.group_by(&:parent_category)
    sorted_groups = grouped_categories.sort_by { |_parent, categories| -categories.size }
    sorted_groups.reverse.to_h
  end

  def self.ransackable_attributes(auth_object = nil)
    ["description", "name", "related_terms"]
  end

  def self.prepared_categories_for_practice_editor
    get_parent_categories.each_with_object({}) do |parent_category, hash|
      categories = parent_category.sub_categories.order_by_name.to_a

      if categories.any? && parent_category.name != "Communities"
        all_cat = new(name: "All #{parent_category.name.downcase}", parent_category: parent_category)
        categories.prepend(all_cat)
      end

      hash[parent_category] = categories
    end
  end

  private

  def clear_caches
    Rails.cache.delete('categories')
    innovable_practices.each(&:clear_searchable_cache)
  end
end
