class CreateFedexInvoiceEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :fedex_invoice_entries do |t|
      t.references :shipping_invoice, null: false, foreign_key: true

      # Core Invoice Fields
      t.string :consolidated_account
      t.string :bill_to_account_number
      t.date :invoice_date
      t.string :invoice_number
      t.string :store_id
      t.decimal :original_amount_due, precision: 10, scale: 2
      t.decimal :current_balance, precision: 10, scale: 2
      t.string :payor

      # Tracking and Charge Information
      t.string :ground_tracking_id_prefix
      t.string :express_or_ground_tracking_id
      t.decimal :transportation_charge_amount, precision: 10, scale: 2
      t.decimal :net_charge_amount, precision: 10, scale: 2
      t.string :service_type
      t.string :ground_service

      # Shipment Information
      t.date :shipment_date
      t.date :pod_delivery_date
      t.string :pod_delivery_time
      t.string :pod_service_area_code
      t.string :pod_signature_description

      # Weight Information
      t.decimal :actual_weight_amount, precision: 10, scale: 2
      t.string :actual_weight_units
      t.decimal :rated_weight_amount, precision: 10, scale: 2
      t.string :rated_weight_units
      t.integer :number_of_pieces
      t.string :bundle_number
      t.string :meter_number
      t.string :td_master_tracking_id

      # Package Information
      t.string :service_packaging
      t.integer :dim_length
      t.integer :dim_width
      t.integer :dim_height
      t.integer :dim_divisor
      t.string :dim_unit

      # Recipient Information
      t.string :recipient_name
      t.string :recipient_company
      t.string :recipient_address_line_1
      t.string :recipient_address_line_2
      t.string :recipient_city
      t.string :recipient_state
      t.string :recipient_zip_code
      t.string :recipient_country

      # Shipper Information
      t.string :shipper_company
      t.string :shipper_name
      t.string :shipper_address_line_1
      t.string :shipper_address_line_2
      t.string :shipper_city
      t.string :shipper_state
      t.string :shipper_zip_code
      t.string :shipper_country

      # Reference Information
      t.string :original_customer_reference
      t.string :original_ref_2
      t.string :original_ref_3_po_number
      t.string :original_department_reference_description
      t.string :updated_customer_reference
      t.string :updated_ref_2
      t.string :updated_ref_3_po_number
      t.string :updated_department_reference_description
      t.string :rma_number

      # Original Recipient Information
      t.string :original_recipient_address_line_1
      t.string :original_recipient_address_line_2
      t.string :original_recipient_city
      t.string :original_recipient_state
      t.string :original_recipient_zip_code
      t.string :original_recipient_country

      # Other Fields
      t.string :zone_code
      t.string :cost_allocation

      # Alternate Address Information
      t.string :alternate_address_line_1
      t.string :alternate_address_line_2
      t.string :alternate_city
      t.string :alternate_state_province
      t.string :alternate_zip_code
      t.string :alternate_country_code

      # Cross Reference Tracking
      t.string :cross_ref_tracking_id_prefix
      t.string :cross_ref_tracking_id

      # Customs and Entry Information
      t.date :entry_date
      t.string :entry_number
      t.decimal :customs_value, precision: 10, scale: 2
      t.string :customs_value_currency_code
      t.decimal :declared_value, precision: 10, scale: 2
      t.string :declared_value_currency_code

      # Currency Information
      t.date :currency_conversion_date
      t.decimal :currency_conversion_rate, precision: 10, scale: 6

      # Multiweight Information
      t.string :multiweight_number
      t.string :multiweight_total_multiweight_units
      t.decimal :multiweight_total_multiweight_weight, precision: 10, scale: 2
      t.decimal :multiweight_total_shipment_charge_amount, precision: 10, scale: 2
      t.decimal :multiweight_total_shipment_weight, precision: 10, scale: 2

      # Address Correction Information
      t.decimal :ground_tracking_id_address_correction_discount_charge_amount, precision: 10, scale: 2
      t.decimal :ground_tracking_id_address_correction_gross_charge_amount, precision: 10, scale: 2

      # Rating and Packaging Information
      t.string :rated_method
      t.string :sort_hub
      t.decimal :estimated_weight, precision: 10, scale: 2
      t.string :estimated_weight_unit
      t.string :postal_class
      t.string :process_category
      t.string :package_size
      t.string :delivery_confirmation
      t.date :tendered_date
      t.string :mps_package_id

      # Store tracking ID charges as JSON array
      t.jsonb :tracking_id_charges

      # Notes
      t.text :shipment_notes

      t.timestamps
    end

    add_index :fedex_invoice_entries, :invoice_date
    add_index :fedex_invoice_entries, :invoice_number
    add_index :fedex_invoice_entries, :express_or_ground_tracking_id
  end
end
