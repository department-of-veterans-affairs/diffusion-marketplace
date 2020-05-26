class InternalUrlValidator < ActiveModel::Validator
  def validate(record)
    url = record.url
    begin
      if url.present?
        # checks if url begins with a "/"
        if url.chars.first != '/'
          raise StandardError.new 'must begin with a "/"'
        end

        route = Rails.application.routes.recognize_path(record.url)

        # checks if the record exists with the specified id
        if route.present? && route[:id].present?
          model = route[:controller].classify
          db_record = model.constantize.find_by(slug: route[:id])
          if db_record.nil?
            raise StandardError.new 'not a valid URL'
          end
        end
      end
    rescue => e
      record.errors.add(:url, e.message)
    end
  end
end
