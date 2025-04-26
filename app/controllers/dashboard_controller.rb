class DashboardController < ApplicationController
  before_action :authenticate_user! # You'll need to implement authentication
  layout "tenant"

  def index
    # Dashboard data for the current tenant
    @company = current_tenant
    @users_count = User.count # This will automatically be scoped to the current tenant due to acts_as_tenant
  end
end
