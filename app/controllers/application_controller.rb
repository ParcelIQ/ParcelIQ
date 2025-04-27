class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include SubdomainRedirector
  include UrlHelper

  helper_method :current_tenant, :is_tenant_domain?, :current_user_is_admin?, :current_user_is_customer?, :generate_customer_dashboard_url

  protected

  def current_tenant
    ActsAsTenant.current_tenant
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path, alert: "Please sign in to access this page."
    end
  end

  def is_tenant_domain?
    request.host.include?(".") &&
      extract_subdomain(request.host).present? &&
      extract_subdomain(request.host) != "www"
  end

  def current_user_is_admin?
    user_signed_in? && current_user.admin?
  end

  def current_user_is_customer?
    user_signed_in? && current_user.customer?
  end

  def require_admin
    unless current_user_is_admin?
      flash[:alert] = "You are not authorized to access this area."
      redirect_to root_path
    end
  end

  # Set tenant from the current user's company if not already set
  def set_tenant_from_current_user
    if ActsAsTenant.current_tenant.nil? &&
       current_user&.customer? &&
       current_user&.company.present?
      ActsAsTenant.current_tenant = current_user.company
    end
  end

  # Redirect after sign in based on user role
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.customer?
      # Redirect customers to their tenant subdomain if they're not already there
      if resource.company.present?
        # Get the subdomain from the company
        subdomain = resource.company.subdomain

        # Check if we're already on this subdomain
        current_subdomain = extract_subdomain(request.host)

        if current_subdomain != subdomain
          # We need to store the target URL in the session and create a custom handling
          # for redirecting to different hosts, since we can't return a URL directly
          # in this method due to Rails' host security checks
          store_location_for(:user, generate_customer_dashboard_url(subdomain: subdomain, host: host_with_port))
          public_root_path
        else
          # We're already on the correct subdomain
          customer_dashboard_path
        end
      else
        # If customer has no company (shouldn't happen with validation), go to root
        tenant_root_path
      end
    elsif is_tenant_domain?
      tenant_root_path
    else
      public_root_path
    end
  end

  private

  def extract_subdomain(host)
    return nil if host.blank?

    # Handle local development with patterns like 'acme.localhost:3000'
    if host.include?("localhost")
      parts = host.split(".")
      return parts.first if parts.size > 1 && parts.first != "www"
    end

    # Original implementation for non-localhost domains
    parts = host.split(".")
    return nil if parts.size <= 2 # No subdomain in example.com

    # For hosts like 'company.example.com', return 'company'
    parts.first if parts.size > 2
  end

  # Helper for full host with port for development environments
  def host_with_port
    if Rails.env.development?
      "localhost:3000"
    else
      request.domain
    end
  end
end
