module FormSpamControllerConcern
  extend ActiveSupport::Concern

  def log_spam_attempt
    debugger
    ip_address = request.remote_ip
    url_orig = request.original_url
    puts "we got you"
    puts ip_address
    puts url_orig
  end

end