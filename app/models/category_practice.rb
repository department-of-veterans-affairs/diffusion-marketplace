class CategoryPractice < ApplicationRecord
  belongs_to :category
  belongs_to :innovable, polymorphic: true

  after_commit :clear_cache_if_practice

  private

  def clear_cache_if_practice
    innovable.clear_searchable_cache if innovable.is_a?(Practice)
  end
end
