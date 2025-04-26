class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_tenant, :is_tenant_domain?, :current_user_is_admin?

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

  def require_admin
    unless current_user_is_admin?
      flash[:alert] = "You are not authorized to access this area."
      redirect_to root_path
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
end
