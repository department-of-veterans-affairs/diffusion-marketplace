# frozen_string_literal: true

class CategoryPractice < ApplicationRecord
  belongs_to :category
  belongs_to :practice
end
