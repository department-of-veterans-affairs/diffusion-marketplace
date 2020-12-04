class CategoryPractice < ApplicationRecord
  belongs_to :category
  belongs_to :practice

  after_save :clear_searchable_practices_cache
  after_destroy :clear_searchable_practices_cache

  def clear_searchable_practices_cache
    practice.clear_searchable_cache
  end
end
