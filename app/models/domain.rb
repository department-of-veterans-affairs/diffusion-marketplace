class Domain < ApplicationRecord
  acts_as_list
  has_many :domain_practices
  has_many :practices, through: :domain_practices
end
