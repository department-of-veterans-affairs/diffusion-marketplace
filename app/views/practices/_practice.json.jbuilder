# frozen_string_literal: true

json.extract! practice, :id, :name, :short_name, :description, :position, :is_vha_field, :is_program_office, :vha_visn, :medical_center, :business_case_summary, :support_network_email, :va_pulse_link, :additional_notes, :created_at, :updated_at
json.url practice_url(practice, format: :json)
