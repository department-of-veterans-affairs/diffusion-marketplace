Devise::Strategies::Authenticatable.class_eval do
  include UserUtils

  private

  def valid_password?
    return true if env["REMOTE_USER"].present?
    Devise::Encryptor.compare(self.class, encrypted_password, password)
  end
end
