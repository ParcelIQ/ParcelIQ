class CreateShippingInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :shipping_invoices do |t|
      t.string :name
      t.references :company, null: false, foreign_key: true
      t.string :carrier
      t.date :invoice_uploaded_date

      t.timestamps
    end

    add_index :shipping_invoices, :carrier
    add_index :shipping_invoices, :invoice_uploaded_date
  end
end
