module Commontator::ApplicationHelper
  include TimeHelper
  include Commontator::UsersHelper
  
  def javascript_proc
    Commontator.javascript_proc.call(self).html_safe
  end
end
