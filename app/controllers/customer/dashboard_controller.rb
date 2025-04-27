module Customer
  class DashboardController < Customer::BaseController
    before_action :authenticate_user!
    before_action :require_customer
    before_action :set_tenant_for_customer
    layout "tenant"

    def index
      @company = current_tenant
      @recent_activity = []  # Placeholder for recent activity data
      @my_info = {
        name: current_user.name,
        email: current_user.email,
        role: current_user.role,
        company: @company.name
      }
    end

    private

    def require_customer
      unless current_user && current_user.customer?
        flash[:alert] = "You are not authorized to access this area."
        redirect_to root_path
      end
    end

    def set_tenant_for_customer
      # If current_tenant is not set by the middleware (based on subdomain)
      # but customer has a company, use that as the current tenant
      if ActsAsTenant.current_tenant.nil? && current_user&.company.present?
        ActsAsTenant.current_tenant = current_user.company
      end
    end
  end
end
