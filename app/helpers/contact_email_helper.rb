module ContactEmailHelper
  def send_contact_email(options = {}, origin, mailer_view_file)
    email = options[:email]
    subject = options[:subject]
    message = options[:message]

    mail(
      from: email,
      to: 'marketplace@va.gov',
      subject: "(#{origin}) #{subject}"
    ) do |format|
      format.html { render "#{mailer_view_file}".html_safe, locals: { message: message } }
    end
  end
end
