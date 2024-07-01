class CategoryPractice < ApplicationRecord
  belongs_to :category
  belongs_to :practice

  after_commit -> { practice.clear_searchable_cache }
end
