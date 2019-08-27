# frozen_string_literal: true

json.extract! clinical_condition, :id, :name, :short_name, :description, :position, :created_at, :updated_at
json.url clinical_condition_url(clinical_condition, format: :json)
