# frozen_string_literal: true

json.extract! impact_category, :id, :name, :short_name, :description, :position, :parent_category_id, :created_at, :updated_at
json.url category_url(impact_category, format: :json)
