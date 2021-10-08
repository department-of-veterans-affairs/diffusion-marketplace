class InternalUrlValidator < ActiveModel::Validator
  include InternalUrlUtils

  def validate(record)
    url = record.url
    begin
      if url.present?
        validate_url(url)
      end
    rescue => e
      record.errors.add(:url, e.message)
    end
  end
end
