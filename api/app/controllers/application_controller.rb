class ApplicationController < ActionController::API
  include Response

  # This enables session storage
  def session
    request.session
  end
end
