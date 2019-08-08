
require 'rack'
require 'rack/auth/ntlm-sso'

class NTLMAuthentication
  def initialize(app)
    @app = app
  end

  def call(env)
    auth = Rack::Auth::NTLMSSO.new(@app)
    auth.call(env)
  end
end