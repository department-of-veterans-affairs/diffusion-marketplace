Devise::Strategies::Authenticatable.class_eval do
  include UserUtils

  private

  def valid_password?
    return true unless check_for_ntlm.first === 401
    Devise::Encryptor.compare(self.class, encrypted_password, password)
  end
end
