# frozen_string_literal: true

json.extract! domain, :id, :name, :short_name, :description, :position, :created_at, :updated_at
json.url domain_url(domain, format: :json)
