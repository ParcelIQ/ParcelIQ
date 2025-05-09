module Customer
  class ReportsController < Customer::BaseController
    before_action :authenticate_user!
    before_action :require_customer
    before_action :set_tenant_for_customer
    before_action :set_company
    layout "tenant"

    def index
      @company = current_tenant

      # Use numerical values for all monetary amounts to enable calculations
      @report_data = {
        customer_name: @company.name,
        invoice_amount: 12345.67,
        invoice_amount_formatted: "$12,345.67",
        shipment_stats: {
          total_amount: 10234.56,
          total_amount_formatted: "$10,234.56",
          shipment_count: 145,
          base_transportation: 7843.12,
          base_transportation_formatted: "$7,843.12",
          surcharge: 1721.44,
          surcharge_formatted: "$1,721.44",
          miscellaneous: 670.00,
          miscellaneous_formatted: "$670.00",
          average_cost: 70.58,
          average_cost_formatted: "$70.58"
        },
        savings: {
          total: 2111.11,
          total_formatted: "$2,111.11",
          transportation_charge: 1209.33,
          transportation_charge_formatted: "$1,209.33",
          surcharge: 487.78,
          surcharge_formatted: "$487.78",
          dimensional: 229.00,
          dimensional_formatted: "$229.00",
          late_shipment_refunds: 185.00,
          late_shipment_refunds_formatted: "$185.00",
          average_per_shipment: 14.56,
          average_per_shipment_formatted: "$14.56"
        },
        previous_agreement_amount: 14456.78,
        previous_agreement_amount_formatted: "$14,456.78",
        new_agreement_amount: 12345.67,
        new_agreement_amount_formatted: "$12,345.67"
      }

      # Calculate savings values
      @savings_amount = @report_data[:previous_agreement_amount] - @report_data[:new_agreement_amount]
      @savings_percentage = (@savings_amount / @report_data[:previous_agreement_amount]) * 100

      # These would be populated from the database in a real implementation
      @available_months = [
        [ "January", 1 ], [ "February", 2 ], [ "March", 3 ], [ "April", 4 ],
        [ "May", 5 ], [ "June", 6 ], [ "July", 7 ], [ "August", 8 ],
        [ "September", 9 ], [ "October", 10 ], [ "November", 11 ], [ "December", 12 ]
      ]
      @available_years = (Date.today.year - 2..Date.today.year).to_a.reverse
      @available_carriers = [ "FedEx", "UPS", "USPS", "DHL" ] # Placeholder
    end

    private

    def require_customer
      unless current_user && current_user.customer?
        flash[:alert] = "You are not authorized to access this area."
        redirect_to root_path
      end
    end

    def set_tenant_for_customer
      # If current_tenant is not set by the middleware (based on subdomain)
      # but customer has a company, use that as the current tenant
      if ActsAsTenant.current_tenant.nil? && current_user&.company.present?
        ActsAsTenant.current_tenant = current_user.company
      end
    end

    def set_company
      @current_company = current_user.company
    end

    helper_method :current_company

    def current_company
      @current_company
    end
  end
end
