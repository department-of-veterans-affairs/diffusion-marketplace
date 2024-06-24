class Category < ApplicationRecord
  include ExtraSpaceRemover

  before_validation :trim_whitespace
  after_commit :clear_caches

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
    strip_attributes([self.name])
  end

  def self.get_parent_categories(is_admin=false)
    Category.order_by_name.select do |cat|
      cat.is_other === false && cat.sub_categories.any? &&
        !(is_admin == false && cat.name == "Communities")
    end
  end

  def self.cached_categories
    Rails.cache.fetch('categories') do
      Category.where(is_other: false).joins(:parent_category).where.not(parent_category: nil).order_by_name.includes(:parent_category).load
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
      categories = parent_category.sub_categories.where(is_other: false).order_by_name.to_a

      if categories.any? && parent_category.name != "Communities"
        all_cat = new(name: "All #{parent_category.name.downcase}", parent_category: parent_category)
        other_cat = new(name: 'Other', parent_category: parent_category)
        categories.prepend(all_cat)
        categories.append(other_cat)
      end

      hash[parent_category] = categories
    end
  end

  private

  def clear_caches
    Rails.cache.delete('categories')
    practices.each(&:clear_searchable_cache)
  end
end
