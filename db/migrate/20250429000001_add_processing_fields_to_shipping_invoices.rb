class AddProcessingFieldsToShippingInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :shipping_invoices, :processing_completed, :boolean, default: false
    add_column :shipping_invoices, :processing_summary, :text
    add_column :shipping_invoices, :processing_started_at, :datetime
    add_column :shipping_invoices, :processing_completed_at, :datetime

    add_index :shipping_invoices, :processing_completed
  end
end
