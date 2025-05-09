module Admin
  class DashboardController < Admin::BaseController
    before_action :authenticate_user!
    before_action :require_admin
    layout "admin"

    def index
      @companies = Company.all
      @users = User.all
      @total_users = User.count
      @total_companies = Company.count
    end

    private

    def require_admin
      unless current_user.admin?
        flash[:alert] = "You are not authorized to access this area."
        redirect_to root_path
      end
    end
  end
end
