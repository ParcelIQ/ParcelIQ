module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_root_admin
    layout "admin"

    protected

    # Skip tenant scope for admin controllers
    def set_tenant_through_filter
      ActsAsTenant.current_tenant = nil
    end
  end
end
