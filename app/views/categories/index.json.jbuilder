# frozen_string_literal: true

json.array! @categories, partial: 'impact_categories/impact_category', as: :category
