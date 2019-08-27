# frozen_string_literal: true

json.extract! job_position_category, :id, :name, :short_name, :description, :position, :parent_category_id, :created_at, :updated_at
json.url job_position_category_url(job_position_category, format: :json)
