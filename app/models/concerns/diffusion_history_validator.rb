class DiffusionHistoryValidator < ActiveModel::Validator
  def validate(record)
    debugger
    is_valid = record.va_facility_id.present? || record.clinical_resource_hub_id.present?
    begin
      unless is_valid
        raise StandardError.new 'No facility or CRH present'
      end
    rescue => e
      record.errors.add(:url, e.message)
    end
  end
end