Devise::Strategies::Authenticatable.class_eval do
  private
  def valid_password?
    true
  end
end
