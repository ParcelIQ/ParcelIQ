module UrlHelpers
  # Define missing path helpers that are needed in tests
  def root_path
    "/"
  end

  def root_url
    "http://test.host/"
  end

  # Add more helpers for devise invitation paths
  def accept_user_invitation_path
    "/users/invitation/accept"
  end

  def accept_user_invitation_url
    "http://test.host/users/invitation/accept"
  end

  # Helper method for Devise invitation in controllers
  def after_invite_path_for(resource)
    root_path
  end
end

RSpec.configure do |config|
  # Include these helpers in controller and request tests
  config.include UrlHelpers, type: :controller
  config.include UrlHelpers, type: :request
end
