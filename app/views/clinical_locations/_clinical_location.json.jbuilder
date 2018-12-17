json.extract! clinical_location, :id, :name, :short_name, :description, :position, :created_at, :updated_at
json.url clinical_location_url(clinical_location, format: :json)
