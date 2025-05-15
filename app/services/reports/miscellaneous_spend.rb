module Reports
  class MiscellaneousSpend < BaseReport
    def calculate
      # Process data in batches and aggregate
      fedex_data, fedex_totals = process_fedex_entries
      ups_data, ups_totals = process_ups_entries

      # Merge data from both carriers
      misc_type_data = merge_data(fedex_data, ups_data)

      # Calculate total spend and shipments
      total_spend = fedex_totals[:sum] + ups_totals[:sum]
      total_shipments = fedex_totals[:count] + ups_totals[:count]

      # Calculate percentages and format results
      result = misc_type_data.map do |misc_type, data|
        percentage = format_percentage(data[:spend], total_spend)
        {
          misc_type: misc_type,
          shipments: data[:shipments],
          spend: data[:spend],
          percentage: percentage
        }
      end

      # Sort by spend (highest first)
      result = result.sort_by { |item| -item[:spend] }

      # Add totals
      {
        items: result,
        total_shipments: total_shipments,
        total_spend: total_spend
      }
    end

    private

    def process_fedex_entries
      process_in_batches(fedex_entries) do |entry|
        misc_charge = ::Parsers::FedexInvoiceParser.misc_charge(entry)
        next if misc_charge.nil? || misc_charge.zero?

        misc_type = ::Parsers::FedexInvoiceParser.misc_type(entry) || "Other"
        [ misc_type, misc_charge, 1 ]
      end
    end

    def process_ups_entries
      process_in_batches(ups_entries) do |entry|
        misc_charge = ::Parsers::UpsInvoiceParser.misc_charge(entry)
        next if misc_charge.nil? || misc_charge.zero?

        misc_type = ::Parsers::UpsInvoiceParser.misc_type(entry) || "Other"
        [ misc_type, misc_charge, 1 ]
      end
    end

    def merge_data(data1, data2)
      merged = data1.deep_dup

      data2.each do |key, values|
        if merged.key?(key)
          merged[key][:shipments] += values[:shipments]
          merged[key][:spend] += values[:spend]
        else
          merged[key] = values
        end
      end

      merged
    end
  end
end
