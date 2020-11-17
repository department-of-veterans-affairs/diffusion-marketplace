# Mailer for form emails.
class CovidCategoryMailer < ApplicationMailer
  default from: ENV['DO_NOT_REPLY_MAILER_SENDER'] || 'do_not_reply@va.gov'
  layout 'mailer'

  def send_covid_category_selections(options = {})
    practice_name = options[:practice_name]
    selected_categories = options[:selected_categories]
    url = options[:url]
    text = ""
    if selected_categories.present?
      text = "Selected Categories:\n"
      selected_categories.each do |sc|
        text = text + sc.name + "\n"
      end
      text = text + "\n\n\n"
    end
    unselected_categories = options[:unselected_categories]
    if unselected_categories.present?
      text = text + "Unselected Categories:\n"
      unselected_categories.each do |uc|
        text = text + uc.name + "\n"
      end
    end
    text = text + "\n\n\n" + "Link to " + practice_name + ": " + url
    subject = "The following covid 19 related categories were added or removed from '" + practice_name + "'"
    mail(to: 'dm@agile6.com', subject: subject, body: text)
  end
end