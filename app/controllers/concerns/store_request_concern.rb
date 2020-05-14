module StoreRequestConcern
  extend ActiveSupport::Concern
  def store_request_in_thread
    Thread.current[:request] = request
  end
end