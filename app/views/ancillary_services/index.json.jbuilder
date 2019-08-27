# frozen_string_literal: true

json.array! @ancillary_services, partial: 'ancillary_services/ancillary_service', as: :ancillary_service
