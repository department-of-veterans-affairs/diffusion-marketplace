# frozen_string_literal: true

json.array! @job_positions, partial: 'job_positions/job_position', as: :job_position
