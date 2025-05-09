class ProcessUpsInvoiceJob < ApplicationJob
  queue_as :default

  def perform(shipping_invoice_id)
    shipping_invoice = ShippingInvoice.find(shipping_invoice_id)

    # Return early if this is not a UPS invoice
    return unless shipping_invoice.carrier == "UPS"

    # Make sure the CSV is attached
    return unless shipping_invoice.csv_file.attached?

    # Mark the start of processing
    shipping_invoice.update(processing_started_at: Time.current)

    # Process the CSV file
    csv_path = ActiveStorage::Blob.service.send(:path_for, shipping_invoice.csv_file.key)
    process_csv(shipping_invoice, csv_path)
  end

  private

  def process_csv(shipping_invoice, csv_path)
    # Open the CSV file and process each row
    row_count = 0
    errors_count = 0

    begin
      CSV.foreach(csv_path, headers: true) do |row|
        next if row.to_h.values.all?(&:nil?) # Skip empty rows

        begin
          create_ups_invoice_entry(shipping_invoice, row)
          row_count += 1
        rescue => e
          errors_count += 1
          Rails.logger.error("Error processing UPS invoice row: #{e.message}")
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
      Rails.logger.error("Error processing UPS invoice file: #{e.message}")
    end
  end

  def create_ups_invoice_entry(shipping_invoice, row)
    # Clean up values and handle formatting issues
    invoice_date = parse_date(row["InvoiceDate"])
    transaction_date = parse_date(row["TransactionDate"])
    invoice_amount = parse_decimal(row["InvoiceAmount"])

    # Create the UPS invoice entry
    entry = shipping_invoice.ups_invoice_entries.create!(
      version: row["Version"],
      recipient_number: row["RecipientNumber"],
      account_number: row["AccountNumber"],
      account_country: row["AccountCountry"],
      invoice_date: invoice_date,
      invoice_number: row["InvoiceNumber"],
      invoice_type_code: row["InvoiceTypeCode"],
      invoice_type_detail_code: row["InvoiceTypeDetailCode"],
      account_tax_id: row["AccountTaxID"],
      invoice_currency_code: row["InvoiceCurrencyCode"],
      invoice_amount: invoice_amount,
      transaction_date: transaction_date,
      pickup_record_number: row["PickupRecordNumber"],
      lead_shipment_number: row["LeadShipmentNumber"],
      world_ease_number: row["WorldEaseNumber"],
      shipment_reference_number1: row["ShipmentReferenceNumber1"],
      shipment_reference_number2: row["ShipmentReferenceNumber2"],
      bill_option_code: row["BillOptionCode"],
      package_quantity: row["PackageQuantity"].to_i,
      oversize_quantity: row["OversizeQuantity"].to_i,
      tracking_number: row["TrackingNumber"],
      package_reference_number1: row["PackageReferenceNumber1"],
      package_reference_number2: row["PackageReferenceNumber2"],
      entered_weight: parse_decimal(row["EnteredWeight"]),
      entered_weight_unit: row["EnteredWeightUnitofMeasure"],
      billed_weight: parse_decimal(row["BilledWeight"]),
      billed_weight_unit: row["BilledWeightUnitofMeasure"],
      container_type: row["ContainerType"],
      billed_weight_type: row["BilledWeightType"],
      package_dimensions: row["PackageDimensions"],
      zone: row["Zone1"],
      charge_category_code: row["ChargeCategoryCode"],
      charge_category_detail_code: row["ChargeCategoryDetailCode"],
      charge_source: row["ChargeSource"],
      charge_classification_code: row["ChargeClassificationCode"],
      charge_description_code: row["ChargeDescriptionCode"],
      charge_description: row["ChargeDescription"],
      charged_unit_quantity: parse_decimal(row["ChargedUnitQuantity"]),
      basis_currency_code: row["BasisCurrencyCode"],
      basis_value: parse_decimal(row["BasisValue"]),
      tax_indicator: row["TaxIndicator"],
      transaction_currency_code: row["TransactionCurrencyCode"],
      incentive_amount: parse_decimal(row["IncentiveAmount"]),
      net_amount: parse_decimal(row["NetAmount"]),
      sender_name: row["SenderName"],
      sender_company_name: row["SenderCompanyName"],
      sender_address_line1: row["SenderAddressLine1"],
      sender_address_line2: row["SenderAddressLine2"],
      sender_city: row["SenderCity"],
      sender_state: row["SenderState"],
      sender_postal: row["SenderPostal"],
      sender_country: row["SenderCountry"],
      receiver_name: row["ReceiverName"],
      receiver_company_name: row["ReceiverCompanyName"],
      receiver_address_line1: row["ReceiverAddressLine1"],
      receiver_address_line2: row["ReceiverAddressLine2"],
      receiver_city: row["ReceiverCity"],
      receiver_state: row["ReceiverState"],
      receiver_postal: row["ReceiverPostal"],
      receiver_country: row["ReceiverCountry"]
    )
  end

  def parse_date(date_string)
    return nil if date_string.blank?

    begin
      # Try common US date format MM/DD/YY
      if date_string =~ %r{\A\d{1,2}/\d{1,2}/\d{2,4}\z}
        Date.strptime(date_string, "%m/%d/%y")
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
end
