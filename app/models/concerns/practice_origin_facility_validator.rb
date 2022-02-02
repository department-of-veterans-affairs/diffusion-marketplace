class PracticeOriginFacilityValidator < ActiveModel::Validator
  def validate(record)
    is_valid = (record.va_facility_id.present? && record.clinical_resource_hub_id.nil?) || (record.va_facility_id.nil? && record.clinical_resource_hub_id.present?)
    begin
      unless is_valid
        raise StandardError.new 'Error! A practice_origin_facility can be associated with either a va_facility or a clinical_resource_hub, but not both.'
      end
    rescue => e
      record.errors.add(:url, e.message)
    end
  end
end