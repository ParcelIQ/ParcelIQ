class DashboardController < ApplicationController
  before_action :authenticate_user! # You'll need to implement authentication
  before_action :set_tenant_for_customer
  layout "tenant"

  def index
    if current_user.admin?
      redirect_to admin_dashboard_path
    elsif current_user.customer?
      # Redirect customers to their tenant subdomain
      if current_user.company.present?
        subdomain = current_user.company.subdomain
        current_subdomain = extract_subdomain(request.host)

        if current_subdomain != subdomain
          # Store the target location and then redirect in a way that allows
          # handling of cross-subdomain redirects via the concern
          host = Rails.env.development? ? "localhost:3000" : request.domain
          target_url = generate_customer_dashboard_url(subdomain: subdomain, host: host)

          # Store the target URL and redirect to trigger our concern
          store_location_for(:user, target_url)
          redirect_to public_root_path
        else
          redirect_to customer_dashboard_path
        end
      else
        # Fallback for any other role (shouldn't happen with current setup)
        @company = current_tenant
        @users_count = User.count
      end
    else
      # Fallback for any other role (shouldn't happen with current setup)
      @company = current_tenant
      @users_count = User.count # This will automatically be scoped to the current tenant due to acts_as_tenant
    end
  end

  private

  def set_tenant_for_customer
    # If current_tenant is not set by the middleware (based on subdomain)
    # but customer has a company, use that as the current tenant
    if ActsAsTenant.current_tenant.nil? && current_user&.customer? && current_user&.company.present?
      ActsAsTenant.current_tenant = current_user.company
    end
  end

  # Use the extract_subdomain method from ApplicationController
  # This is added for clarity as it's inherited from ApplicationController
  def extract_subdomain(host)
    super
  end
end
