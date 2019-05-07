class Risk < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :risk_mitigation
end
