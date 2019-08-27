# frozen_string_literal: true

json.extract! ancillary_service, :id, :name, :short_name, :description, :position, :created_at, :updated_at
json.url ancillary_service_url(ancillary_service, format: :json)
