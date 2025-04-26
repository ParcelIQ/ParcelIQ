RSpec.configure do |config|
  # Devise helpers for controller tests
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Warden helpers for feature/system tests
  config.include Warden::Test::Helpers, type: :feature
  config.include Warden::Test::Helpers, type: :system

  # Reset Warden after each test
  config.after(:each, type: :feature) { Warden.test_reset! }
  config.after(:each, type: :system) { Warden.test_reset! }
end
