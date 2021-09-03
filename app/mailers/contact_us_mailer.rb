class ContactUsMailer < ApplicationMailer
  layout 'mailer'

  def contact_us_email(options = {})
    email = options[:email]
    subject = options[:subject]

    mail(
      from: email,
      to: 'joshua.drumm@agile6.com',
      subject: subject
    ) do |format|
      format.html { render 'contact_us_mailer/contact_us_email'.html_safe, locals: { subject: subject } }
    end
  end
end