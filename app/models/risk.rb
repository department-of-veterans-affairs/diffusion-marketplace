class Risk < ApplicationRecord
  acts_as_list scope: :risk_mitigation
  belongs_to :risk_mitigation
end
