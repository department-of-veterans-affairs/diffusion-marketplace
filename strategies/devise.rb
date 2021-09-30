Devise::Strategies::Authenticatable.class_eval do
  private
  # This is for local development only. As of 9/30/21, the only users we have are VA, and we skip the password validation process altogether
  def valid_password?
    return true if ENV['USE_NTLM'] == 'true'
    Devise::Encryptor.compare(self.class, encrypted_password, password)
  end
end
