# frozen_string_literal: true

json.extract! practice_partner, :id, :name, :short_name, :description, :position, :created_at, :updated_at
json.url practice_partner_url(practice_partner, format: :json)
