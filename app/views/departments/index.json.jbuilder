# frozen_string_literal: true

json.array! @departments, partial: 'departments/department', as: :department
