# frozen_string_literal: true

json.extract! va_secretary_priority, :id, :name, :short_name, :description, :position, :created_at, :updated_at
json.url va_secretary_priority_url(va_secretary_priority, format: :json)
