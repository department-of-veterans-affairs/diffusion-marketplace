# frozen_string_literal: true

json.array! @clinical_conditions, partial: 'clinical_conditions/clinical_condition', as: :clinical_condition
