module Admin
  class CompaniesController < Admin::BaseController
    before_action :require_admin
    before_action :set_company, only: [ :show, :edit, :update, :destroy, :toggle_active ]

    def index
      @companies = Company.all.order(created_at: :desc)
    end

    def show
      @users = User.where(company_id: @company.id)
    end

    def new
      @company = Company.new
    end

    def create
      @company = Company.new(company_params)

      if @company.save
        redirect_to admin_company_path(@company), notice: "Company was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @company.update(company_params)
        redirect_to admin_company_path(@company), notice: "Company was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @company.users.exists?
        redirect_to admin_companies_path, alert: "Cannot delete company because it has users."
      else
        @company.destroy
        redirect_to admin_companies_path, notice: "Company was successfully deleted."
      end
    end

    def toggle_active
      @company.update(active: !@company.active)
      status = @company.active ? "activated" : "deactivated"
      redirect_to admin_companies_path, notice: "Company was successfully #{status}."
    end

    private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(
        :name,
        :subdomain,
        :domain,
        :email,
        :website,
        :phone_number,
        :street_address,
        :city,
        :state,
        :zip,
        :country,
        :tax_id,
        :active,
        :plan,
        :time_zone
      )
    end
  end
end
