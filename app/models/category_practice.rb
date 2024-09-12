class CategoryPractice < ApplicationRecord
  belongs_to :category
  belongs_to :innovable, polymorphic: true

  after_commit -> { innovable.clear_searchable_cache if innovable_type == 'Practice' }
end
