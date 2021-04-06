class ExternalUrlValidator < ActiveModel::Validator
  def validate(record)
    url = record.url
    begin
      # source for regex: https://stackoverflow.com/questions/34561083/how-to-validate-url-in-rails-model
      match = url.match(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix)
      uri = URI.parse(url)
      unless (uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)) && match.present?
        raise StandardError.new 'Not a valid external URL'
      end
    rescue => e
      record.errors.add(:url, e.message)
    end
  end
end
