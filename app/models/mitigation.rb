class Mitigation < ApplicationRecord
  acts_as_list
  belongs_to :risk_mitigation
end
