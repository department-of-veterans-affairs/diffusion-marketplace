# frozen_string_literal: true

json.array! @clinical_locations, partial: 'clinical_locations/clinical_location', as: :clinical_location
