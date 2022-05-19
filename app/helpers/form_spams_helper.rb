module FormSpamsHelper
  def log_spam_attempt(form)
    ip_address = request.remote_ip
    url_orig = request.original_url
    email = params["email"]
    subject = params["subject"]
    message = params["message"]
    phone = params["phone"]
    FormSpam.create(form: form, original_url: url_orig, ip_address: ip_address, email: email, subject: subject, message: message, phone: phone)
  end
end