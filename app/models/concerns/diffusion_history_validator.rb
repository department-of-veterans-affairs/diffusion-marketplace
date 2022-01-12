class DiffusionHistoryValidator < ActiveModel::Validator
  def validate(record)
    is_valid = record.va_facility_id.present? # || record.clinical_resource_hub_id.preset?
    begin
      unless is_valid
        raise StandardError.new 'No facility or CRH present'
      end
    rescue => e
      record.errors.add(:url, e.message)
    end
  end
end