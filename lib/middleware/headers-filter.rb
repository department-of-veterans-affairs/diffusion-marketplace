
require 'rack'
# modified from https://github.com/pusher/rack-headers_filter

class HeadersFilter
  HEADERS_TO_REMOVE = %w[
    HTTP_X_FORWARDED_HOST
    HTTP_X_FORWARDED_PORT
    HTTP_X_FORWARDED_SCHEME
    HTTP_X_FORWARDED_SSL
  ]

  attr_reader :remove_headers

  def initialize(app)
    @remove_headers = HEADERS_TO_REMOVE
    @app = app
  end

  def call(env)
    @remove_headers.each { |header| env.delete(header) }
    env["HTTP_HOST"] = ENV.fetch('HOSTNAME').split('//')[1]
    @app.call(env)
  end
end
