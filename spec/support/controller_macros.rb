# Controller macros for easier authentication in specs
module ControllerMacros
  def login_admin
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      admin = FactoryBot.create(:admin_user)
      sign_in admin
    end
  end

  def login_user
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:customer_user)
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.include ControllerMacros, type: :controller
  config.include ControllerMacros, type: :request
end
