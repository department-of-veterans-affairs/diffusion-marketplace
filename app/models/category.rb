class Category < ApplicationRecord
  include ExtraSpaceRemover

  before_validation :trim_whitespace
  before_save :clear_categories_cache_on_save
  after_save :reset_categories_cache

  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'Category', optional: true
  acts_as_list

  has_many :category_practices, dependent: :destroy
  has_many :practices, through: :categories
  has_many :practices, through: :category_practices

  scope :with_practices,   -> { not_none.joins(:practices).where(practices: {approved: true, published: true, enabled: true} ).order_by_name.uniq }
  scope :order_by_name, -> { order(Arel.sql("lower(categories.name) ASC")) }
  scope :not_none, -> { where.not(name: 'None').where.not(name: 'none') }
  scope :get_category_by_name, -> (cat_name) { where('lower(name) = ?', cat_name.downcase) }
  scope :get_category_names, -> { not_none.pluck(:name) }

  attr_accessor :related_terms_raw
  attr_accessor :reset_cached_categories

  def related_terms_raw
    self[:related_terms].join(", ") unless self[:related_terms].nil?
  end

  def trim_whitespace
    strip_attributes([self.name])
  end

  def self.get_parent_categories(is_admin=false)
    Category.order_by_name.select do |cat|
      cat.sub_categories.any? && !(is_admin == false && cat.name == "Communities")
    end
  end

  def clear_categories_cache
    Cache.new.delete_cache_key('categories')
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

  def self.prepared_categories_for_practice_editor(is_admin)
    get_parent_categories(is_admin).each_with_object({}) do |parent_category, hash|
      categories = parent_category.sub_categories.order_by_name.to_a

      if categories.any? && parent_category.name != "Communities"
        all_cat = new(name: "All #{parent_category.name.downcase}", parent_category: parent_category)
        categories.prepend(all_cat)
      end

      hash[parent_category] = categories
    end
  end
end
