class CompanySettingsController < ApplicationController
  before_action :authenticate_user! # You'll need to implement authentication
  layout "tenant"

  def show
    @company = current_tenant
  end

  def edit
    @company = current_tenant
  end

  def update
    @company = current_tenant

    if @company.update(company_params)
      redirect_to company_settings_path, notice: "Company settings were successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :subdomain, :domain, :time_zone,
                                   :street_address, :city, :state, :zip, :country,
                                   :phone_number, :email, :website, :tax_id, :plan, :logo,
                                   :settings, :metadata)
  end
end
