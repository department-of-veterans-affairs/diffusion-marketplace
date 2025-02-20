class PracticePartnerPractice < ApplicationRecord
  include ActiveModel::Dirty
  belongs_to :practice_partner
  belongs_to :innovable, polymorphic: true

  after_commit -> { innovable.clear_searchable_cache if innovable_type == 'Practice' }

  scope :order_by_id, -> { order(id: :asc) }
end
