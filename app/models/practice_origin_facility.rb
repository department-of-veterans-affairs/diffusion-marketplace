class PracticeOriginFacility <  ApplicationRecord
  include ActiveModel::Dirty

  belongs_to :practice
  belongs_to :va_facility, optional: true
  belongs_to :clinical_resource_hub, optional: true

  attr_accessor :facility_type_and_id

  after_save :clear_searchable_practices_cache
  after_destroy :clear_searchable_practices_cache

  scope :order_by_id, -> { order(id: :asc) }
  scope :get_va_facility_ids_by_practice, -> (practice_id) {
    includes(:va_facility).where(practice_id: practice_id).where.not(va_facility_id: nil).map(&:va_facility_id)
  }
  scope :get_clinical_resource_hub_ids_by_practice, -> (practice_id) {
    includes(:clinical_resource_hub).where(practice_id: practice_id).where.not(clinical_resource_hub_id: nil).map(&:clinical_resource_hub_id)
  }

  validates_with PracticeOriginFacilityValidator, on: [:create, :update] # make sure only one of the optional foreign keys is populated at any given time, either va_facility or clinical_resource_hub

  def clear_searchable_practices_cache
    practice.clear_searchable_cache
  end
end