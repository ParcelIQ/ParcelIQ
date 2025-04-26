class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_tenant

  protected

  def current_tenant
    ActsAsTenant.current_tenant
  end

  def authenticate_user!
    # Implement your authentication logic here
    # For example, if using Devise:
    # redirect_to new_user_session_path unless current_user
  end
end
