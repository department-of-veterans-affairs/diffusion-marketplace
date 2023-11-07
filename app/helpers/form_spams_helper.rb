module FormSpamsHelper
  def log_spam_attempt(form)
    ip_address = request.remote_ip
    url_orig = request.original_url
    FormSpam.create(form: form, original_url: url_orig, ip_address: ip_address)
  end
end