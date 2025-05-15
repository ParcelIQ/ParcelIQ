module Reports
  class BaseReport
    attr_reader :company, :start_date, :end_date, :filters

    # Default batch size for processing entries
    BATCH_SIZE = 1000

    def initialize(company, options = {})
      @company = company
      @start_date = options[:start_date]
      @end_date = options[:end_date]
      @filters = options[:filters] || {}
      @batch_size = options[:batch_size] || BATCH_SIZE
    end

    # Template method to be implemented by subclasses
    def calculate
      raise NotImplementedError, "Subclasses must implement calculate"
    end

    def execute
      result = calculate
      clear_caches
      result
    end

    protected

    def fedex_entries
      FedexInvoiceEntry
        .joins(shipping_invoice: :company)
        .where(shipping_invoice: { company_id: company.id })
        .apply_date_filters(start_date, end_date)
    end

    def ups_entries
      UpsInvoiceEntry
        .joins(shipping_invoice: :company)
        .where(shipping_invoice: { company_id: company.id })
        .apply_date_filters(start_date, end_date)
    end

    def process_in_batches(scope, batch_size = @batch_size)
      data = {}
      total_stats = { count: 0, sum: 0 }

      scope.find_each(batch_size: batch_size) do |entry|
        result = yield(entry)
        next unless result

        key, value, count = result
        data[key] ||= { shipments: 0, spend: 0 }
        data[key][:shipments] += count
        data[key][:spend] += value
        total_stats[:count] += count
        total_stats[:sum] += value
      end

      [ data, total_stats ]
    end

    def format_percentage(value, total)
      total > 0 ? (value / total * 100).round(2) : 0
    end

    private

    def clear_caches
      # Clear parser caches to prevent memory leaks
      ::Parsers::FedexInvoiceParser.clear_cache
      ::Parsers::UpsInvoiceParser.clear_cache
    end
  end
end
