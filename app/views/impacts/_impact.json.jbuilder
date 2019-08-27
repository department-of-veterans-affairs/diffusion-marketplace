# frozen_string_literal: true

json.extract! impact, :id, :name, :short_name, :description, :position, :category, :created_at, :updated_at
json.url impact_url(impact, format: :json)
