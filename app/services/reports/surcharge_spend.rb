module Reports
  class SurchargeSpend < BaseReport
    def calculate
      # Process data in batches and aggregate
      fedex_data, fedex_totals = process_fedex_entries
      ups_data, ups_totals = process_ups_entries

      # Merge data from both carriers
      surcharge_type_data = merge_data(fedex_data, ups_data)

      # Calculate total spend and shipments
      total_spend = fedex_totals[:sum] + ups_totals[:sum]
      total_shipments = fedex_totals[:count] + ups_totals[:count]

      # Calculate percentages and format results
      result = surcharge_type_data.map do |surcharge_type, data|
        percentage = format_percentage(data[:spend], total_spend)
        {
          surcharge_type: surcharge_type,
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
      data = {}
      total_stats = { count: 0, sum: 0 }

      fedex_entries.find_each(batch_size: @batch_size) do |entry|
        # Process tracking_id_charges JSON column
        tracking_charges = entry.tracking_id_charges
        next unless tracking_charges.is_a?(Array) && tracking_charges.any?

        tracking_charges.each do |charge|
          next unless charge.is_a?(Hash) && charge["description"].present? && charge["amount"].present?

          surcharge_type = charge["description"]
          surcharge_amount = charge["amount"].to_f

          next if surcharge_amount.zero?

          data[surcharge_type] ||= { shipments: 0, spend: 0 }
          data[surcharge_type][:shipments] += 1
          data[surcharge_type][:spend] += surcharge_amount
          total_stats[:count] += 1
          total_stats[:sum] += surcharge_amount
        end
      end

      [ data, total_stats ]
    end

    def process_ups_entries
      process_in_batches(ups_entries) do |entry|
        surcharge = ::Parsers::UpsInvoiceParser.surcharge_amount(entry)
        next if surcharge.nil? || surcharge.zero?

        surcharge_type = ::Parsers::UpsInvoiceParser.surcharge_type(entry) || "Other"
        [ surcharge_type, surcharge, 1 ]
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
