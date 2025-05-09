module Parsers
  class UpsInvoiceParser
    # Maps common report fields to the actual columns in the UPS invoice
    FIELD_MAPPINGS = {
      # Base transportation
      service_type: :service_level,
      base_charge: :transportation_charge,

      # Surcharges
      surcharge_type: :accessorial_code,
      surcharge_amount: :accessorial_charge,

      # Miscellaneous
      misc_type: :other_charge_code,
      misc_charge: :other_charge_amount
    }

    class << self
      def service_type(entry)
        get_value(entry, :service_type)
      end

      def base_charge(entry)
        get_value(entry, :base_charge).to_f
      end

      def surcharge_type(entry)
        get_value(entry, :surcharge_type)
      end

      def surcharge_amount(entry)
        get_value(entry, :surcharge_amount).to_f
      end

      def misc_type(entry)
        get_value(entry, :misc_type)
      end

      def misc_charge(entry)
        get_value(entry, :misc_charge).to_f
      end

      def get_value(entry, field)
        return nil if entry.nil?

        # Get the actual column name from the mapping
        column = FIELD_MAPPINGS[field]
        return nil if column.nil?

        # Cache accessor results for performance
        @entry_cache ||= {}
        @entry_cache[entry.id] ||= {}

        if @entry_cache[entry.id].key?(column)
          return @entry_cache[entry.id][column]
        end

        # Try to get the value from the entry
        if entry.respond_to?(column) && entry.has_attribute?(column)
          value = entry.send(column)
          @entry_cache[entry.id][column] = value
          value
        else
          # For debugging purposes - in production, return a sensible default
          Rails.logger.debug("UPS entry doesn't have column #{column}")
          nil
        end
      end

      # Clear cache to avoid memory leaks
      def clear_cache
        @entry_cache = {}
      end
    end
  end
end
