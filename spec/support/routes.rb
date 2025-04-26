RSpec.configure do |config|
  # Include URL helpers in controller and request tests
  config.include Rails.application.routes.url_helpers, type: :controller
  config.include Rails.application.routes.url_helpers, type: :request
end
