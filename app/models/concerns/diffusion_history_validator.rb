class DiffusionHistoryValidator < ActiveModel::Validator
  def validate(record)
    is_valid = record.va_facility_id.present? || record.clinical_resource_hub_id.present?
    has_multiple_relationships = (record.va_facility_id.present? && record.clinical_resource_hub_id.present?) || (record.va_facility_id.present? && record.clinical_resource_hub_id.present?)
    begin
      if !is_valid
        raise StandardError.new 'Error! A DiffusionHistory must belong to either a VaFacility or a ClinicalResourceHub.'
      elsif has_multiple_relationships
        raise StandardError.new 'Error! A DiffusionHistory can belong to either a VaFacility or a ClinicalResourceHub, but not both.'
      end
    rescue => e
      record.errors.add(:url, e.message)
    end
  end
end