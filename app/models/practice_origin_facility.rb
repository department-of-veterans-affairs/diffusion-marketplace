class PracticeOriginFacility <  ApplicationRecord
  include ActiveModel::Dirty

  belongs_to :practice
  belongs_to :va_facility, optional: true
  belongs_to :clinical_resource_hub, optional: true

  after_save :clear_searchable_practices_cache
  after_destroy :clear_searchable_practices_cache

  validates_with PracticeOriginFacilityValidator, on: [:create, :update] # make sure only one of the optional foreign keys is populated at any given time, either va_facility or clinical_resource_hub

  def clear_searchable_practices_cache
    practice.clear_searchable_cache
  end
end