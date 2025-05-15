module PriorSpend
  class Fetcher
    def initialize(company)
      @company = company
    end

    def transportation_spend
      fetch_data_by_type("transportation")
    end

    def surcharge_spend
      fetch_data_by_type("surcharge")
    end

    def dimensional_spend
      fetch_data_by_type("dimensional")
    end

    def per_shipment_spend
      fetch_data_by_type("per_shipment")
    end

    def total_transportation_spend
      transportation_spend.sum { |_service_type, data| data[:spend] }
    end

    def total_surcharge_spend
      surcharge_spend.sum { |_surcharge_type, data| data[:spend] }
    end

    def total_dimensional_spend
      dimensional_spend.sum { |_service_type, data| data[:spend] }
    end

    private

    def fetch_data_by_type(spend_type)
      result = {}

      @company.prior_spends.where(spend_type: spend_type).each do |prior_spend|
        result[prior_spend.service_type] ||= {
          shipments: 0,
          spend: 0.0
        }

        result[prior_spend.service_type][:shipments] += prior_spend.shipment_count
        result[prior_spend.service_type][:spend] += prior_spend.spend_amount
      end

      result
    end
  end
end
