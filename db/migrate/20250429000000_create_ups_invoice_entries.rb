class CreateUpsInvoiceEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :ups_invoice_entries do |t|
      t.references :shipping_invoice, null: false, foreign_key: true

      # Core Invoice Fields
      t.string :version
      t.string :recipient_number
      t.string :account_number
      t.string :account_country
      t.date :invoice_date
      t.string :invoice_number
      t.string :invoice_type_code
      t.string :invoice_type_detail_code
      t.string :account_tax_id
      t.string :invoice_currency_code
      t.decimal :invoice_amount, precision: 10, scale: 2
      t.date :transaction_date

      # Shipment Details
      t.string :pickup_record_number
      t.string :lead_shipment_number
      t.string :world_ease_number
      t.string :shipment_reference_number1
      t.string :shipment_reference_number2
      t.string :bill_option_code
      t.integer :package_quantity
      t.integer :oversize_quantity
      t.string :tracking_number
      t.string :package_reference_number1
      t.string :package_reference_number2

      # Weight Information
      t.decimal :entered_weight, precision: 10, scale: 2
      t.string :entered_weight_unit
      t.decimal :billed_weight, precision: 10, scale: 2
      t.string :billed_weight_unit
      t.string :container_type
      t.string :billed_weight_type
      t.string :package_dimensions

      # Charge Information
      t.string :zone
      t.string :charge_category_code
      t.string :charge_category_detail_code
      t.string :charge_source
      t.string :charge_classification_code
      t.string :charge_description_code
      t.string :charge_description
      t.decimal :charged_unit_quantity, precision: 10, scale: 2

      # Financial Information
      t.string :basis_currency_code
      t.decimal :basis_value, precision: 10, scale: 2
      t.string :tax_indicator
      t.string :transaction_currency_code
      t.decimal :incentive_amount, precision: 10, scale: 2
      t.decimal :net_amount, precision: 10, scale: 2

      # Address Information
      t.string :sender_name
      t.string :sender_company_name
      t.string :sender_address_line1
      t.string :sender_address_line2
      t.string :sender_city
      t.string :sender_state
      t.string :sender_postal
      t.string :sender_country
      t.string :receiver_name
      t.string :receiver_company_name
      t.string :receiver_address_line1
      t.string :receiver_address_line2
      t.string :receiver_city
      t.string :receiver_state
      t.string :receiver_postal
      t.string :receiver_country

      t.timestamps
    end

    add_index :ups_invoice_entries, :invoice_date
    add_index :ups_invoice_entries, :invoice_number
    add_index :ups_invoice_entries, :tracking_number
  end
end
