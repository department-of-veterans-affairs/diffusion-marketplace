# frozen_string_literal: true

json.array! @domains, partial: 'domains/domain', as: :domain
