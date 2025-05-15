module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    layout "admin"

    helper_method :current_company

    protected

    # Skip tenant scope for admin controllers
    def set_tenant_through_filter
      ActsAsTenant.current_tenant = nil
    end

    # Needed for rspec controller tests
    # This is duplicated here for testing, but normally would only be in the ApplicationController
    def after_invite_path_for(resource)
      root_path
    end

    private

    def require_admin
      unless current_user && current_user.admin?
        flash[:alert] = "You are not authorized to access this area."
        redirect_to root_path
      end
    end

    def current_company
      if params[:company_id].present?
        Company.find_by(id: params[:company_id])
      else
        # For admin users working across companies, default to first company
        # This is a fallback when not specifically working with a company
        Company.first
      end
    end
  end
end
