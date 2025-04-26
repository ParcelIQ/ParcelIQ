module Admin
  class TestController < ActionController::Base
    # Use layouts/admin.html.erb
    layout "admin"

    before_action :authenticate_user!
    before_action :require_admin

    def index
      render plain: "Test Controller"
    end

    private

    def authenticate_user!
      unless defined?(current_user) && current_user
        render plain: "Access Denied - Authentication Required", status: :unauthorized
      end
    end

    def require_admin
      unless defined?(current_user) && current_user && current_user.admin?
        flash[:alert] = "You are not authorized to access this area."
        render plain: "Access Denied - Admin Required", status: :forbidden
      end
    end
  end
end
