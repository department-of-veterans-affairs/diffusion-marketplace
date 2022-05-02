
require 'rack'
require 'rack/auth/ntlm-sso'

class NTLMAuthentication
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    public_ips = [
      '10.236.28.70',
      '10.237.28.70',
      '10.238.28.70',
      '10.239.28.70',
      '10.236.28.71',
      '10.237.28.71',
      '10.238.28.71',
      '10.239.28.71',
      '10.236.28.72',
      '10.237.28.72',
      '10.238.28.72',
      '10.239.28.72'
    ]

    unless public_ips.include?(request.env["HTTP_X_FORWARDED_FOR"].split(',').first)
      auth = Rack::Auth::NTLMSSO.new(@app)
      auth.call(env)
    end
    @app.call(env)
  end
end
