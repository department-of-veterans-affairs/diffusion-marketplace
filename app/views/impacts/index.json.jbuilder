# frozen_string_literal: true

json.array! @impacts, partial: 'impacts/impact', as: :categories
