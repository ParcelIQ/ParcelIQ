class ProcessFedexInvoiceJob < ApplicationJob
  queue_as :default

  # Add class variable to store charges during processing
  @@invoice_charges_map = {}

  def perform(shipping_invoice_id)
    shipping_invoice = ShippingInvoice.find(shipping_invoice_id)

    # Return early if this is not a FedEx invoice
    return unless shipping_invoice.carrier == "FedEx"

    # Make sure the CSV is attached
    return unless shipping_invoice.csv_file.attached?

    # Mark the start of processing
    shipping_invoice.update(processing_started_at: Time.current)

    # Process the CSV file
    csv_path = ActiveStorage::Blob.service.send(:path_for, shipping_invoice.csv_file.key)

    # Try a direct file parse first to extract charges accurately
    extract_charges_from_file(shipping_invoice, csv_path)

    # Then proceed with normal processing
    process_csv(shipping_invoice, csv_path)
  end

  private

  def process_csv(shipping_invoice, csv_path)
    # Open the CSV file and process each row
    row_count = 0
    errors_count = 0

    begin
      # Clear any existing entries to avoid duplicates
      shipping_invoice.fedex_invoice_entries.destroy_all
      Rails.logger.info "Cleared existing FedEx invoice entries for shipping_invoice_id=#{shipping_invoice.id}"

      CSV.foreach(csv_path, headers: true) do |row|
        next if row.to_h.values.all?(&:nil?) # Skip empty rows
        next if row["Invoice Date"].blank? # Skip header rows or non-data rows

        begin
          create_fedex_invoice_entry(shipping_invoice, row)
          row_count += 1
        rescue => e
          errors_count += 1
          Rails.logger.error("Error processing FedEx invoice row: #{e.message}")
          Rails.logger.error(e.backtrace.join("\n"))
        end
      end

      # Update the shipping invoice with processing info
      shipping_invoice.update(
        processing_completed: true,
        processing_completed_at: Time.current,
        processing_summary: "Processed #{row_count} rows with #{errors_count} errors."
      )
    rescue => e
      shipping_invoice.update(
        processing_completed: true,
        processing_completed_at: Time.current,
        processing_summary: "Error processing file: #{e.message}"
      )
      Rails.logger.error("Error processing FedEx invoice file: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
    end
  end

  def create_fedex_invoice_entry(shipping_invoice, row)
    # Parse dates and decimals
    invoice_date = parse_date(row["Invoice Date"])
    shipment_date = parse_date(row["Shipment Date"])
    pod_delivery_date = parse_date(row["POD Delivery Date"])
    entry_date = parse_date(row["Entry Date"])
    currency_conversion_date = parse_date(row["Currency Conversion Date"])
    tendered_date = parse_date(row["Tendered Date"])

    # Extract tracking ID related charges and create JSON array
    tracking_id_charges = []

    # Try to get charges based on invoice number from our temporary storage
    invoice_number = row["Invoice Number"]
    if invoice_number.present? && @@invoice_charges_map[invoice_number].present?
      # Get charges for this specific invoice
      invoice_charges = @@invoice_charges_map[invoice_number]

      if invoice_charges.is_a?(Array) && invoice_charges.any?
        Rails.logger.info "Using pre-extracted charges for invoice #{invoice_number}: #{invoice_charges.inspect}"

        # Convert to the right format
        tracking_id_charges = invoice_charges.map do |charge|
          {
            description: charge[:description] || charge["description"],
            amount: parse_decimal(charge[:amount] || charge["amount"])
          }
        end
      end
    end

    # Fall back to CSV extraction if we don't have direct charges
    if tracking_id_charges.empty?
      Rails.logger.info "No pre-extracted charges found, falling back to CSV extraction"
      tracking_id_charges = extract_tracking_id_charges(row)
    end

    # DEBUGGING: Log the charges before saving
    Rails.logger.info "BEFORE CREATING ENTRY - TRACKING CHARGES: #{tracking_id_charges.inspect}"

    # Create the FedEx invoice entry
    entry = shipping_invoice.fedex_invoice_entries.create!(
      consolidated_account: row["Consolidated Account"],
      bill_to_account_number: row["Bill to Account Number"],
      invoice_date: invoice_date,
      invoice_number: invoice_number,
      store_id: row["Store ID"],
      original_amount_due: parse_decimal(row["Original Amount Due"]),
      current_balance: parse_decimal(row["Current Balance"]),
      payor: row["Payor"],
      ground_tracking_id_prefix: row["Ground Tracking ID Prefix"],
      express_or_ground_tracking_id: row["Express or Ground Tracking ID"],
      transportation_charge_amount: parse_decimal(row["Transportation Charge Amount"]),
      net_charge_amount: parse_decimal(row["Net Charge Amount"]),
      service_type: row["Service Type"],
      ground_service: row["Ground Service"],
      shipment_date: shipment_date,
      pod_delivery_date: pod_delivery_date,
      pod_delivery_time: row["POD Delivery Time"],
      pod_service_area_code: row["POD Service Area Code"],
      pod_signature_description: row["POD Signature Description"],
      actual_weight_amount: parse_decimal(row["Actual Weight Amount"]),
      actual_weight_units: row["Actual Weight Units"],
      rated_weight_amount: parse_decimal(row["Rated Weight Amount"]),
      rated_weight_units: row["Rated Weight Units"],
      number_of_pieces: row["Number of Pieces"].to_i,
      bundle_number: row["Bundle Number"],
      meter_number: row["Meter Number"],
      td_master_tracking_id: row["TDMasterTrackingID"],
      service_packaging: row["Service Packaging"],
      dim_length: row["Dim Length"].to_i,
      dim_width: row["Dim Width"].to_i,
      dim_height: row["Dim Height"].to_i,
      dim_divisor: row["Dim Divisor"].to_i,
      dim_unit: row["Dim Unit"],
      recipient_name: row["Recipient Name"],
      recipient_company: row["Recipient Company"],
      recipient_address_line_1: row["Recipient Address Line 1"],
      recipient_address_line_2: row["Recipient Address Line 2"],
      recipient_city: row["Recipient City"],
      recipient_state: row["Recipient State"],
      recipient_zip_code: row["Recipient Zip Code"],
      recipient_country: row["Recipient Country/Territory"],
      shipper_company: row["Shipper Company"],
      shipper_name: row["Shipper Name"],
      shipper_address_line_1: row["Shipper Address Line 1"],
      shipper_address_line_2: row["Shipper Address Line 2"],
      shipper_city: row["Shipper City"],
      shipper_state: row["Shipper State"],
      shipper_zip_code: row["Shipper Zip Code"],
      shipper_country: row["Shipper Country/Territory"],
      original_customer_reference: row["Original Customer Reference"],
      original_ref_2: row["Original Ref#2"],
      original_ref_3_po_number: row["Original Ref#3/PO Number"],
      original_department_reference_description: row["Original Department Reference Description"],
      updated_customer_reference: row["Updated Customer Reference"],
      updated_ref_2: row["Updated Ref#2"],
      updated_ref_3_po_number: row["Updated Ref#3/PO Number"],
      updated_department_reference_description: row["Updated Department Reference Description"],
      rma_number: row["RMA#"],
      original_recipient_address_line_1: row["Original Recipient Address Line 1"],
      original_recipient_address_line_2: row["Original Recipient Address Line 2"],
      original_recipient_city: row["Original Recipient City"],
      original_recipient_state: row["Original Recipient State"],
      original_recipient_zip_code: row["Original Recipient Zip Code"],
      original_recipient_country: row["Original Recipient Country/Territory"],
      zone_code: row["Zone Code"],
      cost_allocation: row["Cost Allocation"],
      alternate_address_line_1: row["Alternate Address Line 1"],
      alternate_address_line_2: row["Alternate Address Line 2"],
      alternate_city: row["Alternate City"],
      alternate_state_province: row["Alternate State Province"],
      alternate_zip_code: row["Alternate Zip Code"],
      alternate_country_code: row["Alternate Country/Territory Code"],
      cross_ref_tracking_id_prefix: row["CrossRefTrackingID Prefix"],
      cross_ref_tracking_id: row["CrossRefTrackingID"],
      entry_date: entry_date,
      entry_number: row["Entry Number"],
      customs_value: parse_decimal(row["Customs Value"]),
      customs_value_currency_code: row["Customs Value Currency Code"],
      declared_value: parse_decimal(row["Declared Value"]),
      declared_value_currency_code: row["Declared Value Currency Code"],
      currency_conversion_date: currency_conversion_date,
      currency_conversion_rate: parse_decimal(row["Currency Conversion Rate"]),
      multiweight_number: row["Multiweight Number"],
      multiweight_total_multiweight_units: row["Multiweight Total Multiweight Units"],
      multiweight_total_multiweight_weight: parse_decimal(row["Multiweight Total Multiweight Weight"]),
      multiweight_total_shipment_charge_amount: parse_decimal(row["Multiweight Total Shipment Charge Amount"]),
      multiweight_total_shipment_weight: parse_decimal(row["Multiweight Total Shipment Weight"]),
      ground_tracking_id_address_correction_discount_charge_amount: parse_decimal(row["Ground Tracking ID Address Correction Discount Charge Amount"]),
      ground_tracking_id_address_correction_gross_charge_amount: parse_decimal(row["Ground Tracking ID Address Correction Gross Charge Amount"]),
      rated_method: row["Rated Method"],
      sort_hub: row["Sort Hub"],
      estimated_weight: parse_decimal(row["Estimated Weight"]),
      estimated_weight_unit: row["Estimated Weight Unit"],
      postal_class: row["Postal Class"],
      process_category: row["Process Category"],
      package_size: row["Package Size"],
      delivery_confirmation: row["Delivery Confirmation"],
      tendered_date: tendered_date,
      mps_package_id: row["MPS Package ID"],
      tracking_id_charges: tracking_id_charges,
      shipment_notes: row["Shipment Notes"]
    )

    # DEBUGGING: Verify charges after saving
    Rails.logger.info "AFTER CREATING ENTRY - SAVED TRACKING CHARGES: #{entry.tracking_id_charges.inspect}"

    entry
  end

  def extract_tracking_id_charges(row)
    # More dynamic approach to handle an arbitrary number of charge pairs
    charges = []

    # If the row object supports direct field access, use it
    if row.respond_to?(:fields) && row.fields.is_a?(Array)
      # First find all "Tracking ID Charge Description" fields and their values
      description_fields = []
      amount_fields = []

      row.headers.each_with_index do |header, index|
        if header.is_a?(String) && header.include?("Tracking ID Charge Description")
          # Found a description field
          if row.fields[index].present?
            description_fields << { index: index, value: row.fields[index] }
          end
        elsif header.is_a?(String) && header.include?("Tracking ID Charge Amount")
          # Found an amount field
          if row.fields[index].present? && row.fields[index].to_s =~ /^[\d\.\,]+$/
            amount_fields << { index: index, value: row.fields[index] }
          end
        end
      end

      # Log what we found
      Rails.logger.info "Found #{description_fields.length} description fields and #{amount_fields.length} amount fields"

      # Match descriptions with amounts based on their sequence
      descriptions_by_index = description_fields.sort_by { |f| f[:index] }
      amounts_by_index = amount_fields.sort_by { |f| f[:index] }

      # Create pairs - we can only create as many pairs as we have of both types
      max_pairs = [ descriptions_by_index.length, amounts_by_index.length ].min

      max_pairs.times do |i|
        desc = descriptions_by_index[i][:value]
        amt = amounts_by_index[i][:value]

        charges << {
          description: desc,
          amount: parse_decimal(amt)
        }

        Rails.logger.info "Added charge pair #{i+1}: #{desc} / #{amt}"
      end
    end

    # Return the charges, ensuring no duplicates
    charges.uniq
  end

  def parse_date(date_string)
    return nil if date_string.blank?

    begin
      # FedEx uses YYYYMMDD format
      if date_string =~ /\A\d{8}\z/
        Date.strptime(date_string, "%Y%m%d")
      else
        # Fallback to Rails' default parsing
        Date.parse(date_string)
      end
    rescue
      nil
    end
  end

  def parse_decimal(decimal_string)
    return nil if decimal_string.blank?

    # Remove commas and other non-numeric characters except decimal point
    clean_string = decimal_string.to_s.gsub(/[^0-9.-]/, "")

    # Return as a decimal or nil if it can't be parsed
    begin
      BigDecimal(clean_string)
    rescue
      nil
    end
  end

  def extract_charges_from_file(shipping_invoice, csv_path)
    begin
      Rails.logger.info "Attempting direct file parsing for charges"

      # Clear any previous data
      @@invoice_charges_map = {}

      # Read the raw file content
      raw_content = File.read(csv_path)

      # Split by lines to process each row
      lines = raw_content.split("\n")

      if lines.length > 1
        # Skip header row and get first data row
        first_data_row = lines[1]

        # Find the start of the tracking charges section
        # This typically begins with "Tracking ID Charge Description" in the header row
        header_row = lines[0]
        charge_section_start_index = header_row.index("Tracking ID Charge Description")

        if charge_section_start_index
          Rails.logger.info "Found charges section in header at position #{charge_section_start_index}"

          # Process all rows (skip header)
          lines.each_with_index do |line, index|
            next if index == 0  # Skip header row
            next if line.blank? || line.to_s.strip.empty?  # Skip empty lines

            # Extract data from this row
            row_fields = line.split(",")
            invoice_number = row_fields[3].to_s.strip
            next if invoice_number.blank?  # Skip if no invoice number

            # Get charge section for this row
            if charge_section_start_index && charge_section_start_index < line.length
              row_charge_section = line[charge_section_start_index..-1] || ""
              row_charge_fields = row_charge_section.split(",")

              # Extract charges using pair logic
              row_charges = []
              j = 0
              while j < row_charge_fields.length - 1
                desc = row_charge_fields[j].to_s.strip
                amt = row_charge_fields[j + 1].to_s.strip

                if desc.present? && amt.present? && amt.match?(/^[\d\.]+$/)
                  row_charges << { description: desc, amount: amt }
                  j += 2
                else
                  j += 1
                end
              end

              # If we found charges for this row
              if row_charges.any?
                Rails.logger.info "Row #{index+1} (Invoice ##{invoice_number}): Found #{row_charges.length} charges"

                # Add to the temporary map
                @@invoice_charges_map[invoice_number] = row_charges
              end
            end
          end

          Rails.logger.info "Extracted charges for #{@@invoice_charges_map.keys.length} invoices"
        else
          Rails.logger.info "Could not find 'Tracking ID Charge Description' in header row"
        end
      end
    rescue => e
      Rails.logger.error "Error in direct file parsing: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
