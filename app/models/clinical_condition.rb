# frozen_string_literal: true

class ClinicalCondition < ApplicationRecord
  acts_as_list
  has_many :clinical_condition_practices
  has_many :practices, through: :clinical_condition_practices
end
