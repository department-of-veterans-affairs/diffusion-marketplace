Devise::Strategies::Authenticatable.class_eval do
  private
  def valid_password?
    return true if ENV['USE_NTLM'] == 'true'
    Devise::Encryptor.compare(self.class, encrypted_password, password)
  end
end
