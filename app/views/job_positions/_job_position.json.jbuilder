json.extract! job_position, :id, :name, :short_name, :description, :position, :job_position_category_id, :created_at, :updated_at
json.url job_position_url(job_position, format: :json)
