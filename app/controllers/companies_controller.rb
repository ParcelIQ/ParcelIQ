class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      # Optionally create an initial admin user here
      redirect_to tenant_root_url(subdomain: @company.subdomain), notice: "Your account has been created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :subdomain, :domain, :time_zone,
                                   :street_address, :city, :state, :zip, :country,
                                   :phone_number, :email, :website, :tax_id, :plan, :logo)
  end
end
