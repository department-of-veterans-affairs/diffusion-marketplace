class PracticePartnerPractice < ApplicationRecord
  include ActiveModel::Dirty
  belongs_to :practice_partner
  belongs_to :practice

  after_commit -> { practice.clear_searchable_cache }

  scope :order_by_id, -> { order(id: :asc) }
end
