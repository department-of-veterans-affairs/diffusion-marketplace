class ApplicationController < ActionController::Base

  private

  def facilities_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/va_gov_facilities_all_response.json"))
  end
end
